require "test_helper"

class Public::ListsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_lists_create_url
    assert_response :success
  end

  test "should get update" do
    get public_lists_update_url
    assert_response :success
  end

  test "should get edit" do
    get public_lists_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get public_lists_destroy_url
    assert_response :success
  end
end
