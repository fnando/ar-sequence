# frozen_string_literal: true

require "mysql_test_helper"

class MysqlSequenceTest < Minitest::Test
  include MysqlTestHelper

  setup do
    recreate_table_in_mysql
  end

  test "adds sequence with default values" do
    mysqldb_with_migration do
      def up
        create_sequence :position
      end
    end.up

    assert_equal 1, Ware.connection.nextval(:position)
    assert_equal 2, Ware.connection.nextval(:position)
  end

  test "adds sequence reader within inherited class" do
    mysqldb_with_migration do
      def up
        create_sequence :position
      end
    end.up

    assert_equal 1, InheritedWare.connection.nextval(:position)
    assert_equal 2, InheritedWare.connection.nextval(:position)
  end

  test "adds sequence starting at 100" do
    mysqldb_with_migration do
      def up
        create_sequence :position, start: 100
      end
    end.up

    assert_equal 100, Ware.connection.nextval(:position)
    assert_equal 101, Ware.connection.nextval(:position)
  end

  test "adds sequence incremented by 2" do
    mysqldb_with_migration do
      def up
        create_sequence :position, increment: 2
      end
    end.up

    assert_equal 1, Ware.connection.nextval(:position)
    assert_equal 3, Ware.connection.nextval(:position)
  end

  test "adds sequence incremented by 2 (using :step alias)" do
    mysqldb_with_migration do
      def up
        create_sequence :position, step: 2
      end
    end.up

    assert_equal 1, Ware.connection.nextval(:position)
    assert_equal 3, Ware.connection.nextval(:position)
  end

  test "returns current/last sequence value without incrementing it" do
    mysqldb_with_migration do
      def up
        create_sequence :position
      end
    end.up

    Ware.connection.nextval(:position)

    assert_equal 1, Ware.connection.currval(:position)
    assert_equal 1, Ware.connection.lastval(:position)
    assert_equal 1, Ware.connection.currval(:position)
    assert_equal 1, Ware.connection.lastval(:position)
  end

  test "sets sequence value" do
    mysqldb_with_migration do
      def up
        create_sequence :position
      end
    end.up

    Ware.connection.nextval(:position)
    assert_equal Ware.connection.currval(:position), 1

    # in mariaDB, 'lastval' only works after 'nextval' rather than  'setval'
    Ware.connection.setval(:position, 101)
    Ware.connection.nextval(:position)
    assert_equal Ware.connection.lastval(:position), 102
  end

  test "drops sequence" do
    mysqldb_with_migration do
      def up
        create_sequence :position
      end

      def down
        drop_sequence :position
      end

      up
      down
    end

    sequence = MysqlDB.connection.check_sequences.find do |seq|
      seq["sequence_name"] == "position"
    end

    assert_nil sequence
  end

  test "orders sequences" do
    mysqldb_with_migration do
      def up
        drop_table :wares, if_exists: true
        create_sequence :c
        create_sequence :a
        create_sequence :b
      end
    end.up

    list = MysqlDB.connection.check_sequences
    p = list.map {|s| s["Tables_in_test"] }
    assert_equal p, %w[a b c]
  end

  # TODO: Come up with and compose an example of a test.
  test "dumps schema" do
  end

  test "does not dump auto-generated sequences to schema" do
    mysqldb_with_migration do
      def up
        drop_table :wares
        create_table :wares, id: :serial do |t|
          t.text :name
        end
      end
    end.up

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(MysqlDB.connection, stream)
    contents = stream.tap(&:rewind).read

    refute_match(/create_sequence/, contents)
  end

  test "creates table that references sequence" do
    mysqldb_with_migration do
      def up
        drop_table :wares
        create_sequence :position
        create_table :wares do |t|
          t.text :name
          t.bigint :position, null: false, default: -> { "nextval(`position`)" }
        end
      end
    end.up

    assert_equal 1, Ware.create(name: "WARE 1").reload.position
    assert_equal 2, Ware.create(name: "WARE 2").reload.position
  end
end
