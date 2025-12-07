require "test_helper"

class ListsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users, :lists

  setup do
    @user = users(:one)

    @user.create_user_setting!(
      default_date_range_list_display: "this_month", # or a valid enum key / value
      default_currency: "AUD",
      notification_lead_time: 7
    ) unless @user.user_setting

    sign_in @user
    @list = lists(:one)
  end

  test "should get index" do
    get lists_url
    assert_response :success
  end

  test "should get new" do
    get new_list_url
    assert_response :success
  end

  test "should create list" do
    assert_difference("List.count", 1) do
      post lists_url, params: {
        list: {
          name: "My test list",
          user_id: @user.id
          # add any *required* fields for List here if it still fails to save,
          # e.g.:
          # price: 123.45,
          # effective_start_date: Date.today
        }
      }
    end

    assert_redirected_to list_url(List.last)
  end

  test "should show list" do
    get list_url(@list)
    assert_response :success
  end

  test "should get edit" do
    get edit_list_url(@list)
    assert_response :success
  end

  test "should update list" do
    patch list_url(@list), params: {
      list: { name: "Updated name" }
    }

    assert_redirected_to list_url(@list)
  end

  test "should destroy list" do
    assert_difference("List.count", -1) do
      delete list_url(@list)
    end

    assert_redirected_to lists_url
  end
end
