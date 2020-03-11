require 'test_helper'

class EpisodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @episode = Episode.new(newsletter_status: :not_sent,
                draft: true,
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
                ** Friday: IAC no-ticket open day")
    ENV['scraper_bot_token']    = 'h07gFJI6oI70swd4clX5PIoUKiToUZ'
    ENV['scraper_bot_timeout']  = 1.minute.from_now.to_json
  end

  # test "bot should fail with invalid token" do
  #   ENV['test_skip_authorized'] = 'false'
  #   payload = {number:            @episode.number,
  #              title:             @episode.title,
  #              slug:              @episode.slug,
  #              description:       @episode.description,
  #              publish_date:      @episode.publish_date,
  #              notes:             @episode.notes,
  #              draft:             @episode.draft,
  #              newsletter_status: 'not scheduled'}
  #   assert_raise ActionController::RoutingError do
  #     post episodes_url, params: payload, as: :json
  #   end
  # end

  # test "bot should fail validation if file params not sent as json" do
  #   file = Rails.root + 'test/fixtures/files/' + '0.jpg'
  #   payload = { bot_token: 'h07gFJI6oI70swd4clX5PIoUKiToUZ',
  #                   caption: "Here's a caption!",
  #                   file: file}
  #   assert_raise ActiveSupport::MessageVerifier::InvalidSignature do
  #     patch( upload_image_path(episodes(:one).number), params: payload, as: :json )
  #   end
  # end

  # test "bot post episode" do
  #   assert_difference('Episode.count') do
  #     payload = {number:            @episode.number,
  #                title:             @episode.title,
  #                slug:              @episode.slug,
  #                description:       @episode.description,
  #                publish_date:      @episode.publish_date,
  #                notes:             @episode.notes,
  #                draft:             @episode.draft,
  #                newsletter_status: 'not scheduled',
  #                bot_token:         'h07gFJI6oI70swd4clX5PIoUKiToUZ'}
  #     post episodes_url, params: payload, as: :json
  #   end
  #   assert_response :success
  # end

  # test "bot upload images" do
  #   files = ['0.jpg', '1.jpg', '2.png']

  #   assert_difference 'episodes(:one).images.count', 3 do
  #     for f in files do
  #       file = fixture_file_upload("files/#{f}", :binary)
  #       payload = { bot_token: 'h07gFJI6oI70swd4clX5PIoUKiToUZ',
  #                   caption: "Here's a caption!",
  #                   file: file}
  #       patch( upload_image_path(episodes(:one).number), params: payload )
  #     end
  #   end
  #   episodes(:one).images.each do |image|
  #     assert image.image.attached?
  #   end
  # end

  # test "bot upload audio" do
  #   file = fixture_file_upload('files/Episode-241.mp3', 'audio/mpeg', :binary)

  #   payload = { bot_token: 'h07gFJI6oI70swd4clX5PIoUKiToUZ',
  #               file: file}
  #   patch( upload_audio_path(episodes(:one).number), params: payload )
  #   # Above, image.image checks the db for the relation, then .attached? refers to the db object.
  #   # Here, episodes(:one).audio.attached? would just refer to a fixture. We could instead start
  #   # this test with e = Episode.new() or similar, but this just seems cleaner.
  #   assert Episode.find_by(number: episodes(:one).number).audio.attached?
  # end

end
