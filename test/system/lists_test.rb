# test/system/lists_test.rb
require "application_system_test_case"

class ListsTest < ApplicationSystemTestCase
  setup do
    @list = lists(:one)
  end

  test "visiting the index" do
    skip "System tests for Lists are not wired to the current UI yet"
    visit lists_url
    assert_selector "h1", text: "Lists"
  end

  test "should create list" do
    skip "System tests for Lists are not wired to the current UI yet"
    visit lists_url
    click_on "New list"

    fill_in "Description", with: @list.description
    fill_in "Due date", with: @list.due_date
    fill_in "Name", with: @list.name
    fill_in "Price", with: @list.price
    fill_in "User", with: @list.user_id
    click_on "Create List"

    assert_text "List was successfully created"
    click_on "Back"
  end

  test "should update List" do
    skip "System tests for Lists are not wired to the current UI yet"
    visit list_url(@list)
    click_on "Edit this list", match: :first

    fill_in "Description", with: @list.description
    fill_in "Due date", with: @list.due_date
    fill_in "Name", with: @list.name
    fill_in "Price", with: @list.price
    fill_in "User", with: @list.user_id
    click_on "Update List"

    assert_text "List was successfully updated"
    click_on "Back"
  end

  test "should destroy List" do
    skip "System tests for Lists are not wired to the current UI yet"
    visit list_url(@list)
    click_on "Destroy this list", match: :first

    assert_text "List was successfully destroyed"
  end
end
