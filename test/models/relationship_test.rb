require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(
      follower_id: users(:michael).id,
      followed_id: users(:archer).id
    )
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "create again same record should be fail" do
    @invalid_relationship = Relationship.new(
      follower_id: users(:michael).id,
      followed_id: users(:archer).id
    )
    @relationship.save
    assert @relationship.persisted?
    @invalid_relationship.save
    assert_not @invalid_relationship.persisted?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
