require "application_system_test_case"

class EpisodesTest < ApplicationSystemTestCase
  TITLE_REGEX = /(Episode [0-9]{3}: )(DOWNLINK--|DATA RELAY--){0,1}[\w\s]*/

  setup do
    @episode = {publish_year: '2020',
                publish_month: 'January',
                publish_day: '7',
                number: 242,
                title: 'DOWNLINK--Dr. Martin Elvis',
                slug: 'martin-elvis',
                description: "Asteroid mining is often discussed in terms of engineering and economics. Today, we're talking about raw material availability.",
                notes: "Spaceflight news
                        *ISRO confirms plans for Chandrayaan-3 (spacenews.com)
                        **Chandrayaan-2 imagery (nasa.gov)
                        Short & Sweet
                        *SpaceX plans a moveable tower for pad 39A (spaceflightnow.com)
                        *Christina Koch breaks a record (spaceflightnow.com)
                        *Early signs of the Clean Space age: Iridium announces willingness to pay for third party cleanup of failed satellites (spacenews.com)
                        Interview: Dr. Martin Elvis, Senior Astrophysicist, Center for Astrophysics and Smithsonian
                        *harvard.edu/~elvis
                        *Simulated population of asteroids from mikael granvik (helsinki.fi)
                        This week in SF history
                        *10 January 2015: first droneship landing attempt (wikipedia.org)
                        *Next week in 1977: black side down"}
    @old_episode = {publish_year: '2019',
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
                   ** Friday: IAC no-ticket open day"}
  end

  # test "visiting the index before logging in" do
  #   visit root_url
  #   assert_selector "h1", text: "The Orbital Mechanics Podcast"
  #   assert_selector 'h2', text: TITLE_REGEX, count: Settings.views.number_of_homepage_episodes
  #   assert_link 'More episodes...', href: episodes_path
  #   assert_no_link text: /edit/i
  #   assert_no_link text: /episode draft/i
  #   assert_no_link text: /email subscribers/i
  #   assert_no_link text: /log Out/i
  # end

  # test "viewing an episode before logging in" do
  #   visit "/#{episodes(:one).slug}"
  #   assert_selector 'h2', text: Episode.full_title(episodes(:one).number, episodes(:one).title), count: 1
  #   assert_text "Previous Episode", count: 1
  #   assert_no_text "Next Episode"
  # end

  # test 'Logging in and visiting the index' do
  #   visit login_url
  #   assert_selector 'h1', text: 'Login'
  #   assert_field 'Email'
  #   assert_field 'Password'
  #   assert_button 'Login'
  # end

  test "Publishing an episode, zero to 60" do
    # Check login redirect to draft
    visit draft_url
    assert_current_path login_path
    fill_in 'Email', with: users(:admin).email
    fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
    click_on 'Login'
    assert_current_path draft_path
    assert_text "Authentication successful!"

    # Check the draft page contents
    assert page.has_field? 'Number', with: episodes(:one).number + 1
    assert_text "Newsletter status\nnot scheduled"
    assert_button 'Save as draft'
    assert_no_button 'Draft and schedule newsletter'
    assert_no_button 'Cancel scheduled newsletter'
    assert_no_button 'Publish'
    assert_no_button 'Publish changes'
    assert_no_text 'Show'
    assert_text 'Back'
    assert_no_text 'Remove'

    # Create partial draft and save it, checking placeholder slug
    fill_in "Number",       with: @episode[:number]
    select(@episode[:publish_year],  from: 'episode_publish_date_1i')
    select(@episode[:publish_month], from: 'episode_publish_date_2i')
    select(@episode[:publish_day],   from: 'episode_publish_date_3i')
    fill_in "Notes",        with: @episode[:notes]
    click_on "Save as draft"
    assert_current_path "/episodes/untitled-draft/edit"
    assert_text 'Episode draft was successfully created.'
    assert page.has_field? 'Slug', with: 'untitled-draft'
    assert_text "Newsletter status\nnot scheduled"

    # Finish filling in the draft, checking slug generation
    fill_in "Title",        with: @episode[:title]
    fill_in "Description",  with: @episode[:description]
    click_on "Save as draft"
    assert_text 'Episode draft was successfully updated.'
    assert page.has_field? 'Slug', with: @episode[:slug]
    assert_text "Newsletter status\nnot scheduled"

    # Attach some images
    files = ['0.jpg', '1.jpg', '2.png'].map {|x| Rails.root + 'test/fixtures/files/' + x}
    attach_file 'episode_images', files
    click_on "Save as draft"
    image_ids = Episode.find_by(number: @episode[:number]).images.pluck(:id).map(&:to_s)
    assert page.has_field? "image_positions[#{image_ids[0]}]", type: 'text', with: '1', count: 1
    assert page.has_field? "image_positions[#{image_ids[1]}]", type: 'text', with: '2', count: 1
    assert page.has_field? "image_positions[#{image_ids[2]}]", type: 'text', with: '3', count: 1

    # Assign titles
    fill_in "image_captions[#{image_ids[0]}]", with: "this is image 1"
    fill_in "image_captions[#{image_ids[1]}]", with: "this is image 2"
    fill_in "image_captions[#{image_ids[2]}]", with: "this is image 3"
    click_on "Save as draft"
    assert page.has_field? "image_captions[#{image_ids[0]}]", type: 'text', with: "this is image 1", count: 1
    assert page.has_field? "image_captions[#{image_ids[1]}]", type: 'text', with: "this is image 2", count: 1
    assert page.has_field? "image_captions[#{image_ids[2]}]", type: 'text', with: "this is image 3", count: 1

    # Reorder images
    fill_in "image_positions[#{image_ids[1]}]", with: "5"
    click_on "Save as draft"
    assert page.has_field? "image_positions[#{image_ids[0]}]", type: 'text', with: '1', count: 1
    assert page.has_field? "image_positions[#{image_ids[1]}]", type: 'text', with: '3', count: 1
    assert page.has_field? "image_positions[#{image_ids[2]}]", type: 'text', with: '2', count: 1

    # Delete an image
    check "remove_image[#{image_ids[0]}]"
    click_on "Save as draft"
    assert_not page.has_field? "image_positions[#{image_ids[0]}]", type: 'text'
    assert page.has_field?     "image_positions[#{image_ids[1]}]", type: 'text', with: '2', count: 1
    assert page.has_field?     "image_positions[#{image_ids[2]}]", type: 'text', with: '1', count: 1

    # Schedule the newsletter
    click_on 'Draft and schedule newsletter'
    assert_text 'Episode draft was successfully updated.'
    assert_text "Newsletter status\nscheduled"

    # Check that the draft is displayed on the home page
    click_on 'Back'
    click_on 'The Orbital Mechanics Podcast'
    assert_selector 'h2', text: Episode.full_title(@episode[:number], @episode[:title]), count: 1

    # Check that the draft is not displayed while logged out
    click_on 'Log Out'
    assert_current_path root_path
    assert_selector 'h2', text: Episode.full_title(@episode[:number], @episode[:title]), count: 0

    # Check login redirect to homepage
    visit login_url
    fill_in 'Email', with: users(:admin).email
    fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
    click_on 'Login'
    assert_current_path root_path
    assert_text "Authentication successful!"
    assert_selector 'h2', text: Episode.full_title(@episode[:number], @episode[:title]), count: 1
    assert_link 'Edit', href: "/episodes/#{@episode[:slug]}/edit"

    # Publish the episode
    click_on 'Episode draft'
    assert page.has_field? 'Number', with: @episode[:number]
    click_on 'Publish'
    assert_text 'Episode was successfully published.'
    assert_text "Draft\nfalse"
    assert_text "Newsletter status\nscheduled"

    # Check that the published episode and scheduled newsletter job is on the homepage
    click_on 'Back'
    assert_current_path episodes_path
    click_on 'The Orbital Mechanics Podcast'
    assert_current_path root_path
    assert_selector 'h2', text: Episode.full_title(@episode[:number], @episode[:title]), count: 1
    assert_selector 'h2', text: /(Episode [0-9]{3}: )(DOWNLINK--|DATA RELAY--)?[\w\s]/,
                          count: Settings.views.number_of_homepage_episodes
    assert_text "Scheduled jobs (1)"

    # Log out and check that the episode is still present, but the scheduled job isn't.
    click_on 'Log Out'
    assert_selector 'h2', text: Episode.full_title(@episode[:number], @episode[:title]), count: 1
    assert_text "Scheduled jobs (1)", count: 0
end

  # test "Trying to publish an episode without handling the newsletter" do
  #   visit login_url

  #   fill_in 'Email', with: users(:admin).email
  #   fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
  #   click_on 'Login'

  #   visit draft_path
  #   fill_in "Number",       with: @episode[:number]
  #   fill_in "Title",        with: @episode[:title]
  #   fill_in "Slug",         with: @episode[:slug]
  #   select(@episode[:publish_year],  from: 'episode_publish_date_1i')
  #   select(@episode[:publish_month], from: 'episode_publish_date_2i')
  #   select(@episode[:publish_day],   from: 'episode_publish_date_3i')
  #   fill_in "Description",  with: @episode[:description]
  #   fill_in "Notes",        with: @episode[:notes]
  #   click_on "Save as draft"
  #   click_on "Publish"

  #   assert_text "Can't publish if the newsletter hasn't been handled."
  #   assert_text "Draft\ntrue"
  #   assert_text 'not scheduled'
  # end

  # test "Trying to publish an episode that's missing its notes" do
  #   visit login_url

  #   fill_in 'Email', with: users(:admin).email
  #   fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
  #   click_on 'Login'
  #   assert_current_path root_path

  #   visit episodes_url
  #   click_on "Edit", match: :first

  #   fill_in "Number",       with: @episode[:number]
  #   fill_in "Title",        with: @episode[:title]
  #   fill_in "Slug",         with: @episode[:slug]
  #   select(@episode[:publish_year],  from: 'episode_publish_date_1i')
  #   select(@episode[:publish_month], from: 'episode_publish_date_2i')
  #   select(@episode[:publish_day],   from: 'episode_publish_date_3i')
  #   fill_in "Description",  with: @episode[:description]
  #   fill_in "Notes",        with: ''
  #   click_on "Publish"

  #   assert_text "Notes can't be blank"
  # end

  # # test "Trying to save an episode draft with too short of a title" do
  # #   visit login_url

  # #   fill_in 'Email', with: users(:admin).email
  # #   fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
  # #   click_on 'Login'
  # #   assert_current_path root_path

  # #   visit episodes_url
  # #   click_on "Edit", match: :first

  # #   fill_in "Number",       with: @episode[:number]
  # #   fill_in "Title",        with: 'asdf'
  # #   fill_in "Slug",         with: @episode[:slug]
  # #   select(@episode[:publish_year],  from: 'episode_publish_date_1i')
  # #   select(@episode[:publish_month], from: 'episode_publish_date_2i')
  # #   select(@episode[:publish_day],   from: 'episode_publish_date_3i')
  # #   fill_in "Description",  with: @episode[:description]
  # #   fill_in "Notes",        with: @episode[:notes]
  # #   click_on "Save as draft"

  # #   assert_text "Title is too short"
  # # end

  # test "Trying to publish an episode with a non-unique attributes" do
  #   visit login_url

  #   fill_in 'Email', with: users(:admin).email
  #   fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
  #   click_on 'Login'
  #   assert_current_path root_path

  #   visit episodes_url
  #   click_on "Edit", match: :first

  #   fill_in "Number",       with: episodes(:two).number
  #   fill_in "Title",        with: episodes(:two).title
  #   fill_in "Slug",         with: episodes(:two).slug
  #   select(@episode[:publish_year],  from: 'episode_publish_date_1i')
  #   select(@episode[:publish_month], from: 'episode_publish_date_2i')
  #   select(@episode[:publish_day],   from: 'episode_publish_date_3i')
  #   fill_in "Description",  with: @episode[:description]
  #   fill_in "Notes",        with: @episode[:notes]
  #   click_on "Publish"

  #   assert_text "Number has already been taken"
  #   assert_text "Title has already been taken"
  #   assert_text "Slug has already been taken"
  # end

  # test "Loading draft if the draft is old" do
  #   # Test what you fly, right? Found a bug where episode#draft wasn't loading the most recent draft properly
  #   # because before implementing the default scope, I'd wound up sorting incorrectly in the now depricated
  #   # most_recent_draft method, and it wound up loading an already-published episode.
  #   visit draft_url
  #   fill_in 'Email', with: users(:admin).email
  #   fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
  #   click_on 'Login'

  #   # Check the draft page contents
  #   assert page.has_field? 'Number', with: episodes(:one).number + 1
  #   assert_no_text 'Show'
  #   assert_text 'Back'
  #   assert_no_text 'Remove'

  #   # Fill in an old episode
  #   fill_in "Number",       with: @old_episode[:number]
  #   fill_in "Title",        with: @old_episode[:title]
  #   select(@old_episode[:publish_year],  from: 'episode_publish_date_1i')
  #   select(@old_episode[:publish_month], from: 'episode_publish_date_2i')
  #   select(@old_episode[:publish_day],   from: 'episode_publish_date_3i')
  #   fill_in "Description",  with: @old_episode[:description]
  #   fill_in "Notes",        with: @old_episode[:notes]
  #   click_on "Save as draft"
  #   assert_text 'Episode draft was successfully created.'

  #   # Check the draft was loaded correctly on draft page.
  #   visit draft_url
  #   assert_current_path "/episodes/#{@old_episode[:slug]}/edit"
  # end

  # test "previous/next buttons on episodes" do
  #   visit login_url
  #   fill_in 'Email', with: users(:admin).email
  #   fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
  #   click_on 'Login'

  #   # Pick an episode in the "middle" of the stack, "yank it" back to draft.
  #   visit "/#{episodes(:four).slug}"
  #   assert_selector 'h2', text: Episode.full_title(episodes(:four).number, episodes(:four).title), count: 1
  #   assert_text "Previous Episode", count: 1
  #   assert_text "Next Episode", count: 1
  #   click_on 'Edit'
  #   assert_text 'Editing an episode'
  #   assert_text "Draft\nfalse"
  #   click_on 'Revert to draft'
  #   assert_text "Draft\ntrue"

  #   # Check that episode n+1 can skip backwards over the yanked episode
  #   visit "/#{episodes(:four).slug}"
  #   assert_text "Previous Episode | Next Episode"
  #   click_on "Next Episode"
  #   assert_current_path "/episodes/#{episodes(:three).slug}"
  #   assert_text "Previous Episode | Next Episode"
  #   click_on "Previous Episode"
  #   assert_current_path "/episodes/#{episodes(:five).slug}"

  #   # Check that episode n-1 can skip forwards
  #   assert_text "Previous Episode | Next Episode"
  #   click_on "Next Episode"
  #   assert_current_path "/episodes/#{episodes(:three).slug}"
  # end

  # test "destroying a Episode" do
  #   visit login_url

  #   fill_in 'Email', with: users(:admin).email
  #   fill_in 'Password', with: 'VSkI3n&r0Q9k2XFZGxUi'
  #   click_on 'Login'
  #   assert_current_path root_path

  #   visit episodes_url
  #   click_on "Edit", match: :first

  #   click_on "Remove"

  #   assert_current_path episodes_path
  #   assert_text "Episode was successfully destroyed"
  # end

end
