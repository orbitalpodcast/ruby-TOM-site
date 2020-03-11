require 'test_helper'

class EpisodesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @episode = Episode.new(newsletter_status: :not_sent,
                draft: true,
                publish_date: "2020-02-11",
                number: 243,
                title: "Ad Astra Per DARPA",
                slug: "ad-astra-per-darpa",
                description: "Astra has obtained permits to launch the third version of their Rocket, and they're now the sole competitor in the DARPA launch challenge.",
                notes: "Spaceflight News
                        *Astra Space obtains launch permits
                        ** Three polar launches from Kodiak https://apps.fcc.gov/oetcf/els/reports/STA_Print.cfm?mode=current&amp;application_seq=93697&amp;RequestTimeout=1000 https://www.faa.gov/about/office_org/headquarters_offices/ast/licenses_permits/media/LLS%2020-118,%20Rocket%20v3.0%20(PSCA),%20Signed%20(2020-01-09)1.pdf
                        **DARPA launch from Wallops https://apps.fcc.gov/oetcf/els/reports/STA_Print.cfm?mode=current&amp;application_seq=97422&amp;RequestTimeout=1000
                        *** Challenge seeks two launches from different locations with little foreknowledge of payload https://www.darpalaunchchallenge.org/
                        *** Downselected to only candidate https://spectrum.ieee.org/tech-talk/aerospace/satellites/fcc-filing-confirms-final-contestant-in-darpas-12-million-satellite-launch-challenge
                        Short & Sweet
                        * Virgin Galactic's second spaceship passes important milestone. https://www.satellitetoday.com/launch/2020/01/08/virgin-galactics-second-spaceship-hits-weight-on-wheels-milestone/
                        * Another lunar lander is in the running. https://spacenews.com/dynetics-sierra-nevada-bidding-on-artemis-lunar-lander/
                        * Starliner joint investigation announced https://spacenews.com/joint-nasa-boeing-team-to-investigate-starliner-test-flight-anomaly/
                        Questions, comments, corrections
                        * https://twitter.com/chairboy/status/1215657902179930112: Gridfins hydraulics
                        ** The hydraulic system is closed loop since ~2015 https://twitter.com/elonmusk/status/878823434268033025?lang=en
                        This week in SF history
                        * 14 Jan 1977: first SCA, N905NA, delivered to Edwards https://www.nasa.gov/sites/default/files/files/1d.pdf https://blog.nationalgeographic.org/2012/09/17/inside-the-space-shuttle-carrier-aircraft/ https://www.nasa.gov/sites/default/files/files/SCA_Historical_Narrative.pdf
                        * Next week in 2004: no need for TIRS")
    @ep_draft = Episode.new(newsletter_status: :not_sent,
                draft: true,
                publish_date: '1-7-2020',
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
                        *Simulated population of asteroidra from mikael granvik (helsinki.fi)
                        This week in SF history
                        *10 January 2015: first droneship landing attempt (wikipedia.org)
                        *Next week in 1977: black side down")
    ENV['test_skip_authorized'] = 'true'
  end

  test "should get index" do
    get episodes_url
    assert_response :success
    assert_select 'h2', {text: EPISODE_TITLE_REGEX,
                         count: Settings.views.number_of_episodes_per_page}
  end

  test "episode pagination" do
    # test default range behavior
    get episodes_path
    default_next_start = episodes(:one).number-9-1
    default_next_end   = episodes(:one).number-9-1-9
    assert_select 'a[href=?]', "/episodes/#{default_next_start}/to/#{default_next_end}"

    # test custom range returns custom ranges from most recent episode
    start_number = episodes(:one).number
    for distance in [3, 5, 12, 15] do
      get episodes_with_range_url start_number,   start_number-distance
      assert_nil assigns(:previous_page_start)
      assert_equal assigns(:next_page_start),     start_number-distance-1
      assert_equal assigns(:next_page_end),       start_number-distance*2-1
    end

    # test custom range returns custom ranges from an old episode
    most_recent = episodes(:one).number
    for start_number in [most_recent-50, most_recent-100]
      for distance in [3, 5, 12, 15] do
        get episodes_with_range_url start_number,   start_number-distance
        assert_equal assigns(:previous_page_start), start_number+1+distance
        assert_equal assigns(:previous_page_end),   start_number+1
        assert_equal assigns(:next_page_start),     start_number-distance-1
        assert_equal assigns(:next_page_end),       start_number-distance*2-1
      end
    end
  end

  test "get index with range using unusual ranges" do
    # Range of 1
    get episodes_with_range_url episodes(:one).number, episodes(:one).number
    assert_select 'h2', {text: EPISODE_TITLE_REGEX, count: 1}

    # Backwards range
    get episodes_with_range_url episodes(:five).number, episodes(:one).number
    assert_select 'h2', {text: EPISODE_TITLE_REGEX, count: 5}

    # Range of non-extant episode numbers
    get episodes_with_range_url 1000, 1020
    assert_response :success
    assert_select 'h2', {text: EPISODE_TITLE_REGEX, count: 0}

    # Range with words
    get episodes_with_range_url 'first', 'last'
    assert_select 'h2', {text: EPISODE_TITLE_REGEX, count: Episode.count}
    # range with mixed numbers and words
    get episodes_with_range_url 'last', episodes(:six).number # last is :one
    assert_select 'h2', {text: EPISODE_TITLE_REGEX, count: 6}
  end

  test "get index skipping drafts" do
    @ep_draft.save

    get episodes_url
    assert_response :success
    assert_select 'h2', {text: @ep_draft.full_title, count: 0}
    assert_select 'h2', {text: EPISODE_TITLE_REGEX,
                         count: Settings.views.number_of_episodes_per_page}

    @ep_draft.destroy
  end

  test "should get new" do
    get root_path
    assert_response :success
  end

  test "should show episode" do
    get episode_url episodes(:one)
    assert_response :success
  end

  test "should create episode" do
    sign_in admins(:ben)
    assert_difference('Episode.count') do
      post episodes_url, params: {episode: @episode.attributes, commit: "Save as draft"}
    end
    assert_redirected_to edit_episode_url(@episode)
    assert_equal 'Episode draft was successfully created.', flash[:notice]
    sign_out :ben
  end

  test "should get edit" do
    sign_in admins(:ben)
    get edit_episode_url episodes(:one)
    assert_response :success
    sign_out :ben
  end

  test "should update episode with new variables" do
    sign_in admins(:ben)
    patch episode_url episodes(:one), params: { episode: { description:   @episode.description,
                                                           notes:         @episode.notes,
                                                           number:        @episode.number,
                                                           publish_date:  @episode.publish_date,
                                                           slug:          @episode.slug,
                                                           title:         @episode.title } }
    assert_template 'episodes/edit'
    assert_equal 'Episode was successfully published.', flash[:notice]
    sign_out :ben
  end

  test "should destroy episode" do
    sign_in admins(:ben)
    assert_difference('Episode.count', -1) do
      delete episode_url episodes(:one)
    end
    sign_out :ben
  end

end
