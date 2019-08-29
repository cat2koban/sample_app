require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
  end

  test "should successfully create a micropost when logged in" do
    log_in_as(@user)
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should successfully destroy a post when logged in" do
    log_in_as(@user)
    assert_difference 'Micropost.count', -1 do
    delete micropost_path(@micropost)
    end
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(@user)
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end
