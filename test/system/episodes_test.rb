require "application_system_test_case"

class EpisodesTest < ApplicationSystemTestCase
  TITLE_REGEX = /(Episode [0-9]{3}: )(DOWNLINK--|DATA RELAY--){0,1}[\w\s]*/

  setup do
    @episode = {newsletter_status: 'not sent',
                publish_year: '2019',
                publish_month: 'September',
                publish_day: '8',
                number: 231,
                title: 'Fewer gyros, more problems',
                slug: 'fewer-gyros-more-problems',
                description: "DSCOVR's safehold seems to be connected to a gryo, but there's a fix coming down the line.",
                notes: "This week in SF history
                * 2000 October 9: HETE-2, first orbital launch from Kwajalein https://en.wikipedia.org/wiki/High_Energy_Transient_Explorer
                * Next week in 1956: listen in for an audio clue.
                Spaceflight News
                * Plans in place to fix DSCOVR https://spacenews.com/software-fix-planned-to-restore-dscovr/
                ** We first reported on this on Ep 218 as an S&S https://spacenews.com/dscovr-spacecraft-in-safe-mode/
                ** Faulty gyro? https://twitter.com/simoncarn/status/1175823150984126464
                *** Triana engineers considered laser gyro failures PDF: https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/20010084979.pdf
                Short & Sweet
                * NASA Mars 2020 tests descent stage separation https://www.jpl.nasa.gov/news/news.php?feature=7513\
                * NASA issues request for information on xEMU. https://www.nasaspaceflight.com/2019/10/nasa-rfi-new-lunar-spacesuits/
                * New Shepard will likely not fly humans in 2019. https://spacenews.com/blue-origin-may-miss-goal-of-crewed-suborbital-flights-in-2019/
                Questions, comments, corrections
                * https://twitter.com/search?q=\%23tomiac2019&amp;f=live\
                ** Sunday: Off Nominal meetups https://events.offnominal.space/
                ** Monday: museum day
                *** Udvar-Hazy and downtown Air and Space Museum
                ** Thursday: Dinner meetup
                *** https://www.mcgintyspublichouse.com/
                *** 911 Ellsworth Dr, Silver Spring, MD 20910
                ** Friday: IAC no-ticket open day"
                }
  end

  test "visiting the index before logging in" do
    visit root_url
    assert_selector "h1", text: "The Orbital Mechanics Podcast"
    assert_selector 'h2', text: TITLE_REGEX, count: Settings.homepage.number_of_episodes
    assert_link 'More episodes...', href: episodes_path
    assert_no_link text: /edit/i
    assert_no_link text: /episode draft/i
    assert_no_link text: /email subscribers/i
    assert_no_link text: /log Out/i
  end

  test 'Logging in and visiting the index' do
    visit login_url
    assert_selector 'h1', text: 'Login'
    assert_field 'Email'
    assert_field 'Password'
    assert_button 'Login'
  end

  test "Creating an Episode draft" do
    visit draft_url
    assert_current_path login_path

    fill_in 'Email', with: users(:admin).email
    fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
    click_on 'Login'
    assert_current_path draft_path

    fill_in "Number",       with: @episode[:number]
    fill_in "Title",        with: @episode[:title]
    fill_in "Slug",         with: @episode[:slug]
    select(@episode[:publish_year],  from: 'episode_publish_date_1i')
    select(@episode[:publish_month], from: 'episode_publish_date_2i')
    select(@episode[:publish_day],   from: 'episode_publish_date_3i')
    fill_in "Description",  with: @episode[:description]
    fill_in "Notes",        with: @episode[:notes]
    click_on "Save as draft"
    assert_current_path "/episodes/#{@episode[:slug]}/edit"
    assert_text 'Draft was successfully created.'
    assert_text 'not scheduled'

    click_on 'Back'
    
    assert_current_path episodes_path
    
    click_on 'The Orbital Mechanics Podcast'
    assert_current_path root_path
    #TODO: Add Episode full title generator method and implement in views and tests
    assert_selector 'h2', text: "Episode #{@episode[:number]}: #{@episode[:title]}", count: 1
  end

  test "Trying to publish an invalid episode" do
    visit draft_url
    assert_current_path login_path

    fill_in 'Email', with: users(:admin).email
    fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
    click_on 'Login'
    assert_current_path draft_path
  end

  test "Editing a published episode" do
    visit login_url

    fill_in 'Email', with: users(:admin).email
    fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
    click_on 'Login'
    assert_current_path root_path

    visit episodes_url
    click_on "Edit", match: :first

    fill_in "Number",       with: @episode[:number]
    fill_in "Title",        with: @episode[:title]
    fill_in "Slug",         with: @episode[:slug]
    select(@episode[:publish_year],  from: 'episode_publish_date_1i')
    select(@episode[:publish_month], from: 'episode_publish_date_2i')
    select(@episode[:publish_day],   from: 'episode_publish_date_3i')
    fill_in "Description",  with: @episode[:description]
    fill_in "Notes",        with: @episode[:notes]
    click_on "Publish"

    # TODO: update episode/edit success flash to reflect whether a draft was saved or an episode was published
    assert_text "Episode was successfully published."
    click_on "Back"
    assert_current_path episodes_path
  end

  test "destroying a Episode" do
    visit login_url

    fill_in 'Email', with: users(:admin).email
    fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
    click_on 'Login'
    assert_current_path root_path

    visit episodes_url
    click_on "Edit", match: :first

    click_on "Remove"

    assert_current_path episodes_path
    assert_text "Episode was successfully destroyed"
  end

end
