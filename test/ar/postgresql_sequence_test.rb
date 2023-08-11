# frozen_string_literal: true

require "postgresql_test_helper"

class PostgresqlSequenceTest < Minitest::Test
  include PostgresqlTestHelper

  setup do
    recreate_table_in_postgresql
  end

  test "adds sequence with default values" do
    postgresql_with_migration do
      def up
        create_sequence :position
      end
    end.up

    assert_equal 1, Thing.connection.nextval(:position)
    assert_equal 2, Thing.connection.nextval(:position)
  end

  test "adds sequence reader within inherited class" do
    postgresql_with_migration do
      def up
        create_sequence :position
      end
    end.up

    assert_equal 1, InheritedThing.connection.nextval(:position)
    assert_equal 2, InheritedThing.connection.nextval(:position)
  end

  test "adds sequence starting at 100" do
    postgresql_with_migration do
      def up
        create_sequence :position, start: 100
      end
    end.up

    assert_equal 100, Thing.connection.nextval(:position)
    assert_equal 101, Thing.connection.nextval(:position)
  end

  test "adds sequence incremented by 2" do
    postgresql_with_migration do
      def up
        create_sequence :position, increment: 2
      end
    end.up

    assert_equal 1, Thing.connection.nextval(:position)
    assert_equal 3, Thing.connection.nextval(:position)
  end

  test "adds sequence incremented by 2 (using :step alias)" do
    postgresql_with_migration do
      def up
        create_sequence :position, step: 2
      end
    end.up

    assert_equal 1, Thing.connection.nextval(:position)
    assert_equal 3, Thing.connection.nextval(:position)
  end

  test "returns current/last sequence value without incrementing it" do
    postgresql_with_migration do
      def up
        create_sequence :position
      end
    end.up

    Thing.connection.nextval(:position)

    assert_equal 1, Thing.connection.currval(:position)
    assert_equal 1, Thing.connection.lastval(:position)
    assert_equal 1, Thing.connection.currval(:position)
    assert_equal 1, Thing.connection.lastval(:position)
  end

  test "sets sequence value" do
    postgresql_with_migration do
      def up
        create_sequence :position
      end
    end.up

    Thing.connection.nextval(:position)
    assert_equal Thing.connection.currval(:position), 1

    Thing.connection.setval(:position, 101)
    assert_equal 101, Thing.connection.currval(:position)
  end

  test "drops sequence" do
    postgresql_with_migration do
      def up
        create_sequence :position
      end

      def down
        drop_sequence :position
      end

      up
      down
    end

    sequence = PostgresqlDB.connection.check_sequences.find do |seq|
      seq["sequence_name"] == "position"
    end

    assert_nil sequence
  end

  test "orders sequences" do
    postgresql_with_migration do
      def up
        drop_table :things, if_exists: true
        create_sequence :c
        create_sequence :a
        create_sequence :b
      end
    end.up

    list = ActiveRecord::Base.connection.check_sequences
    assert_equal list.map {|s| s["sequence_name"] }, %w[a b c]
  end

  test "dumps schema" do
    postgresql_with_migration do
      def up
        create_sequence :a
        create_sequence :b, start: 100
        create_sequence :c, increment: 2
        create_sequence :d, start: 100, step: 2
        create_sequence "my_schema.e"
      end
    end.up

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(PostgresqlDB.connection, stream)
    contents = stream.tap(&:rewind).read

    assert_match(/create_sequence "a"$/, contents)
    assert_match(/create_sequence "b", start: 100$/, contents)
    assert_match(/create_sequence "c", increment: 2$/, contents)
    assert_match(/create_sequence "d", start: 100, increment: 2$/, contents)
    assert_match(/create_sequence "my_schema.e"$/, contents)
  end

  test "does not dump auto-generated sequences to schema" do
    postgresql_with_migration do
      def up
        drop_table :things
        create_table :things, id: :serial do |t|
          t.text :name
        end
      end
    end.up

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(PostgresqlDB.connection, stream)
    contents = stream.tap(&:rewind).read

    refute_match(/create_sequence/, contents)
  end

  test "creates table that references sequence" do
    postgresql_with_migration do
      def up
        drop_table :things
        create_sequence :position
        create_table :things do |t|
          t.text :name
          t.bigint :position, null: false, default: -> { "nextval('position')" }
        end
      end
    end.up

    assert_equal 1, Thing.create(name: "THING 1").reload.position
    assert_equal 2, Thing.create(name: "THING 2").reload.position
  end
end
