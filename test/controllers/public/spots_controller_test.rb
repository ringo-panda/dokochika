require "test_helper"

class Public::SpotsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_spots_new_url
    assert_response :success
  end

  test "should get index" do
    get public_spots_index_url
    assert_response :success
  end

  test "should get create" do
    get public_spots_create_url
    assert_response :success
  end

  test "should get edit" do
    get public_spots_edit_url
    assert_response :success
  end

  test "should get update" do
    get public_spots_update_url
    assert_response :success
  end

  test "should get destroy" do
    get public_spots_destroy_url
    assert_response :success
  end

  test "should get show" do
    get public_spots_show_url
    assert_response :success
  end
end
