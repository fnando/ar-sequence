require "test_helper"

class SequenceTest < Minitest::Test
  include TestHelper

  setup do
    recreate_table
  end

  test "adds sequence with default values" do
    with_migration do
      def up
        create_sequence :position
      end
    end.up

    assert_equal 1, Thing.nextval(:position)
    assert_equal 2, Thing.nextval(:position)
  end

  test "adds sequence reader within inherited class" do
    with_migration do
      def up
        create_sequence :position
      end
    end.up

    assert_equal 1, InheritedThing.nextval(:position)
    assert_equal 2, InheritedThing.nextval(:position)
  end

  test "adds sequence starting at 100" do
    with_migration do
      def up
        create_sequence :position, start: 100
      end
    end.up

    assert_equal 100, Thing.nextval(:position)
    assert_equal 101, Thing.nextval(:position)
  end

  test "adds sequence incremented by 2" do
    with_migration do
      def up
        create_sequence :position, increment: 2
      end
    end.up

    assert_equal 1, Thing.nextval(:position)
    assert_equal 3, Thing.nextval(:position)
  end

  test "adds sequence incremented by 2 (using :step alias)" do
    with_migration do
      def up
        create_sequence :position, step: 2
      end
    end.up

    assert_equal 1, Thing.nextval(:position)
    assert_equal 3, Thing.nextval(:position)
  end

  test "returns current sequence value without incrementing it" do
    with_migration do
      def up
        create_sequence :position
      end
    end.up

    Thing.nextval(:position)

    assert_equal 1, Thing.currval(:position)
    assert_equal 1, Thing.currval(:position)
  end

  test "sets sequence value" do
    with_migration do
      def up
        create_sequence :position
      end
    end.up

    Thing.nextval(:position)
    assert_equal Thing.currval(:position), 1

    Thing.setval(:position, 101)
    assert_equal 101, Thing.currval(:position)
  end

  test "drops sequence" do
    with_migration do
      def up
        create_sequence :position
      end

      def down
        drop_sequence :position
      end

      up
      down
    end

    assert_nil ActiveRecord::Base.connection.check_sequences.find {|seq| seq["sequence_name"] == "position" }
  end

  test "dumps schema" do
    with_migration do
      def up
        create_sequence :a
        create_sequence :b, start: 100
        create_sequence :c, increment: 2
        create_sequence :d, start: 100, step: 2
      end
    end.up

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    contents = stream.tap(&:rewind).read

    assert_match %r{create_sequence "a"$}, contents
    assert_match %r{create_sequence "b", start: 100$}, contents
    assert_match %r{create_sequence "c", increment: 2$}, contents
    assert_match %r{create_sequence "d", start: 100, increment: 2$}, contents
  end

  test "creates table that references sequence" do
    with_migration do
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
