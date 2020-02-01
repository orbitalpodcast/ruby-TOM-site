require 'test_helper'

class EpisodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @episode = {newsletter_status: 'not sent',
                draft: false,
                publish_date: '2019-9-8',
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
    ENV['test_skip_authorized'] = 'true'
  end

  test "should get index" do
    get episodes_url
    assert_response :success
  end

  test "should get new" do
    get root_path
    assert_response :success
  end

  test "should create episode" do
    assert_difference('Episode.count') do
      post episodes_url, params: { episode: { description: @episode[:description],
                                              newsletter_status: @episode[:newsletter_status],
                                              draft: @episode[:draft],
                                              notes: @episode[:notes],
                                              number: @episode[:number],
                                              publish_date: @episode[:publish_date],
                                              slug: @episode[:slug],
                                              title: @episode[:title] } }
    end
    assert_redirected_to edit_episode_url(Episode.last)
  end

  # test "should show episode" do
  #   get episode_url(@episode)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_episode_url(@episode)
  #   assert_response :success
  # end

  # test "should update episode" do
  #   patch episode_url(@episode), params: { episode: { description: @episode.description, notes: @episode.notes, number: @episode.number, publish_date: @episode.publish_date, slug: @episode.slug, title: @episode.title } }
  #   assert_redirected_to episode_url(@episode)
  # end

  # test "should destroy episode" do
  #   assert_difference('Episode.count', -1) do
  #     delete episode_url(@episode)
  #   end

  #   assert_redirected_to episodes_url
  # end
end
