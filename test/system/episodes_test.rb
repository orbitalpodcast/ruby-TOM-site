require "application_system_test_case"

class EpisodesTest < ApplicationSystemTestCase
  setup do
    @episode = episodes(:one)
  end

  test "visiting the index" do
    visit episodes_url
    assert_selector "h1", text: "Episodes"
  end

  test "creating a Episode" do
    visit episodes_url
    click_on "New Episode"

    fill_in "Description", with: @episode.description
    fill_in "Notes", with: @episode.notes
    fill_in "Number", with: @episode.number
    fill_in "Publish date", with: @episode.publish_date
    fill_in "Slug", with: @episode.slug
    fill_in "Title", with: @episode.title
    click_on "Create Episode"

    assert_text "Episode was successfully created"
    click_on "Back"
  end

  test "updating a Episode" do
    visit episodes_url
    click_on "Edit", match: :first

    fill_in "Description", with: @episode.description
    fill_in "Notes", with: @episode.notes
    fill_in "Number", with: @episode.number
    fill_in "Publish date", with: @episode.publish_date
    fill_in "Slug", with: @episode.slug
    fill_in "Title", with: @episode.title
    click_on "Update Episode"

    assert_text "Episode was successfully updated"
    click_on "Back"
  end

  test "destroying a Episode" do
    visit episodes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Episode was successfully destroyed"
  end
end
