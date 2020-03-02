require 'test_helper'

class PublishFlowTest < ActionDispatch::IntegrationTest
  setup do
    TITLE_REGEX = /(Episode [0-9]{3}: )(DOWNLINK--|DATA RELAY--){0,1}[\w\s]*/
    ep_params = {newsletter_status: 'not sent',
                draft: false,
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
                        *Simulated population of asteroids from mikael granvik (helsinki.fi)
                        This week in SF history
                        *10 January 2015: first droneship landing attempt (wikipedia.org)
                        *Next week in 1977: black side down"}
    ep_draft_params = {newsletter_status: 'not sent',
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
                        * Next week in 2004: no need for TIRS"}
    ENV['test_skip_authorized'] = 'true'
  end

  test 'Reverting publish flow for invalid episode' do
    post login_path, params: {email: users(:admin).email, password: 'VSkI3n&r0Q9k2XFZGxUi'}

    # Create new episode
    ep = {newsletter_status: 'not scheduled',
          draft: true,
          slug: '',
          title: '',
          description: '',
          notes: '',
          number: ep_params[:number]}
    assert_difference('Episode.count') do
      post episodes_url, params: {episode: ep, commit: "Save as draft"}
    end
    assert_equal 'Episode draft was successfully created.', flash[:notice]

    # Update attributes, with missing description
    ep = ep_params.clone
    ep[:description] = ''
    assert_no_difference('Episode.count') do
      patch episode_url ep[:number], params: {episode: ep, commit: "Save as draft"}
    end
    assert_equal 'Episode draft was successfully updated.', flash[:notice]
    assert_select "textarea[id=episode_notes]", ep[:notes]

    # Try to publish
    patch episode_url ep[:number], params: {episode: ep, commit: "Publish"}
    assert_match /Can't publish if the newsletter hasn\'t been handled./,
        assigns(:episode).errors.full_messages.first

    # Change the description, then try to publish again. Test that the change was persisted.
    ep[:description] = ep_params[:description]
    patch episode_url ep[:number], params: {episode: ep, commit: "Publish"}
    assert_match /Can't publish if the newsletter hasn\'t been handled./,
        assigns(:episode).errors.full_messages.first
    assert_select "input[id=episode_description]" do
      assert_select '[value=?]', ep[:description]
    end
    assert_select 'div.field' do
      assert_select 'strong', 'true'
    end
  end

  # test 'Warning for missing images during publish flow' do
  # end

  # test 'Overriding newsletter during publish flow' do
  # end

  # test 'Overriding socials during publish flow' do
  # end

end
