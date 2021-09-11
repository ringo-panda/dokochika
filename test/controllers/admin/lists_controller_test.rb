require "test_helper"

class Admin::ListsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get admin_lists_create_url
    assert_response :success
  end

  test "should get update" do
    get admin_lists_update_url
    assert_response :success
  end

  test "should get edit" do
    get admin_lists_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_lists_destroy_url
    assert_response :success
  end

  test "should get index" do
    get admin_lists_index_url
    assert_response :success
  end
end
