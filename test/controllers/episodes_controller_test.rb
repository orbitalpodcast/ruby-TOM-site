require 'test_helper'

class EpisodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @episode = episodes(:one)
  end

  test "convert_markup_to_html format URLs, accounting for twitter and instagram and missing protocol" do
    @string = ["https://www.instagram.com/silvia.draws/",
               "twitter.com/silvia_draws"].join("\n")
    @output = ["(<a href=\"https://www.instagram.com/silvia.draws/\">instagram.com/silvia.draws</a>)",
               "(<a href=\"http://twitter.com/silvia_draws\">twitter.com/silvia_draws</a>)"].join("\n") # assume HTTP not HTTPS
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format URLs, accounting for subreddits and forums" do
    @string = ["Starship overpressure explosion https://spacenews.com/spacex-starship-suffers-testing-setback/",
               "Rumors on 4Chan, via Reddit and NSF forum https://www.reddit.com/r/SpaceXLounge/comments/e055ej/i_can_partially_end_the_speculation_about_why/ https://forum.nasaspaceflight.com/index.php?topic=49114.1540"].join("\n")
    @output = ["Starship overpressure explosion (<a href=\"https://spacenews.com/spacex-starship-suffers-testing-setback/\">spacenews.com</a>)",
               "Rumors on 4Chan, via Reddit and NSF forum (<a href=\"https://www.reddit.com/r/SpaceXLounge/comments/e055ej/i_can_partially_end_the_speculation_about_why/\">/r/SpaceXLounge</a>) (<a href=\"https://forum.nasaspaceflight.com/index.php?topic=49114.1540\">forum.nasaspaceflight.com</a>)"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format URLs, accounting for file type" do
    @string = ["29 October 1998: Launch of STS-95 https://en.wikipedia.org/wiki/STS-95 https://www.nasa.gov/home/hqnews/presskit/1998/sts-95.pdf",
               "Next week in 1974: Solidarity"].join("\n")
    @output = ["29 October 1998: Launch of STS-95 (<a href=\"https://en.wikipedia.org/wiki/STS-95\">en.wikipedia.org</a>) (PDF: <a href=\"https://www.nasa.gov/home/hqnews/presskit/1998/sts-95.pdf\">nasa.gov</a>)",
               "Next week in 1974: Solidarity"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format URLs, accounting for existing parens with no spaces" do
    @string = ["29 October 1998: Launch of STS-95 (https://en.wikipedia.org/wiki/STS-95)",
               "Next week in 1974: Solidarity"].join("\n")
    @output = ["29 October 1998: Launch of STS-95 (<a href=\"https://en.wikipedia.org/wiki/STS-95\">en.wikipedia.org</a>)",
               "Next week in 1974: Solidarity"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format URLs, accounting for existing parens with padding spaces" do
    @string = ["29 October 1998: Launch of STS-95 (   http://foo.com/blah_blah_(wikipedia)_(again))",
               "29 October 1998: Launch of STS-95 (http://foo.com/blah_blah_(wikipedia)_(again)   )",
               "29 October 1998: Launch of STS-95 (   http://foo.com/blah_blah_(wikipedia)_(again) )",
               "Next week in 1974: Solidarity"].join("\n")
    @output = ["29 October 1998: Launch of STS-95 (<a href=\"http://foo.com/blah_blah_(wikipedia)_(again)\">foo.com</a>)",
               "29 October 1998: Launch of STS-95 (<a href=\"http://foo.com/blah_blah_(wikipedia)_(again)\">foo.com</a>)",
               "29 October 1998: Launch of STS-95 (<a href=\"http://foo.com/blah_blah_(wikipedia)_(again)\">foo.com</a>)",
               "Next week in 1974: Solidarity"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format URLs, accounting for hat tips" do
    @string = ["Upgraded H3 rocket for lunar missions https://spacenews.com/mitsubishi-heavy-industries-mulls-upgraded-h3-rocket-variants-for-lunar-missions/",
               "H-IIA had a proposed asymmetric configuration as well as liquid boosters HT Sam in the chat: http://www.b14643.de/Spacerockets_1/Japan/H-IIA_Heavy/Description/Frame.htm"].join("\n")
    @output = ["Upgraded H3 rocket for lunar missions (<a href=\"https://spacenews.com/mitsubishi-heavy-industries-mulls-upgraded-h3-rocket-variants-for-lunar-missions/\">spacenews.com</a>)",
               "H-IIA had a proposed asymmetric configuration as well as liquid boosters (HT Sam in the chat: <a href=\"http://www.b14643.de/Spacerockets_1/Japan/H-IIA_Heavy/Description/Frame.htm\">b14643.de</a>)"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format URLs, allowing escaped full URLs" do
    @string = ["Virgin Orbit announces potential Martian cubesat missions. ///https://www.theverge.com/2019/10/9/20906657/virgin-orbit-mars-vehicle-deep-space-satellite-missions-launcherone-satrevolution"].join("\n")
    @output = ["Virgin Orbit announces potential Martian cubesat missions. (<a href=\"https://www.theverge.com/2019/10/9/20906657/virgin-orbit-mars-vehicle-deep-space-satellite-missions-launcherone-satrevolution\">https://www.theverge.com/2019/10/9/20906657/virgin-orbit-mars-vehicle-deep-space-satellite-missions-launcherone-satrevolution</a>)"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  # Not sure what I want this functionality to look like yet, so I'm just leaving this here for now.
  # test "convert_markup_to_html format in-line links" do
    # @string = [""].join("\n")
    # @output = [""].join("\n")
    # assert_equal @output, Episode.convert_markup_to_HTML(@string)
  # end

  test "convert_markup_to_html handle headers and alternates and leading spaces" do
    @string = ["Short & Sweet",
               "      Spaceflight News",
               "questions, comments, corrections",
               "This week in SF history"].join("\n")
    @output = ["<h3>Short & Sweet</h3>",
               "<h3>Spaceflight News</h3>",
               "<h3>Questions, Comments and Correction Burns</h3>",
               "<h3>This Week in Spaceflight History</h3>"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

    test "convert_markup_to_html handle headers with wildcards in settings" do
    @string = ["Interview -- Dr. Marc Rayman",
               "interview -- Dr. Marc Rayman"].join("\n")

    @output = ["<h3>Interview -- Dr. Marc Rayman</h3>",
               "<h3>Interview -- Dr. Marc Rayman</h3>"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html handle various levels of bullets" do
    @string = ["* topic 1",
               "* topic 2",
               "** topic 2a",
               "* topic 3",
               "** topic 3a",
               "*** topic 3ai"].join("\n")
    @output = ["<ul><li>topic 1</li>",
               "<li>topic 2</li>",
               "<ul><li>topic 2a</li></ul>",
               "<li>topic 3</li>",
               "<ul><li>topic 3a</li>",
               "<ul><li>topic 3ai</li></ul></ul></ul>"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format bold and itallics" do
    @string = ["This show was brought to you by our **patreon supporters** who we simply *love*."].join("\n")
    @output = ["This show was brought to you by our <strong>patreon supporters</strong> who we simply <i>love</i>."].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  # test "convert_markup_to_html can do everything all at once." do
  #   @string = ["This week in SF history",
  #              "* October 17, 1956: Birth of Mae Jemison https://en.wikipedia.org/wiki/Mae_Jemison",
  #              "Spaceflight News",
  #              "* Battery replacement EVAs https://www.americaspace.com/2019/10/07/spacewalkers-begin-three-week-eva-marathon-to-replace-space-station-batteries/",
  #              "    * Commercial crew update https://arstechnica.com/science/2019/10/spacex-targeting-abort-test-late-this-year-crew-flight-soon-after/ https://spacenews.com/nasa-and-spacex-agree-commercial-crew-development-is-the-highest-priority/",
  #              "** Eric Berger says *full panic has ensued* (https://twitter.com/SciGuySpace/status/1181572161917607948)",
  #              "** Dragon done in 10 weeks? HT someone on Twitter: https://twitter.com/elonmusk/status/1181579173388673025",
  #              "Short & Sweet",
  #              "* Virgin Orbit announces potential Martian cubesat missions. https://www.theverge.com/2019/10/9/20906657/virgin-orbit-mars-vehicle-deep-space-satellite-missions-launcherone-satrevolution?bxid=5d892338fc942d4788847f4d&amp;cndid=&amp;esrc=",
  #              "* Stratolaunch is now under new ownership. https://spacenews.com/stratolaunch-gets-mystery-new-owner/",
  #              "* The Jason-2 mission has ended, but its satellite will remain. https://spacenews.com/decommissioned-earth-science-satellite-to-remain-in-orbit-for-centuries"].join("\n")
  #   @output = ["This week in SF history",
  #              "* October 17, 1956: Birth of Mae Jemison https://en.wikipedia.org/wiki/Mae_Jemison",
  #              "Spaceflight News",
  #              "* Battery replacement EVAs https://www.americaspace.com/2019/10/07/spacewalkers-begin-three-week-eva-marathon-to-replace-space-station-batteries/",
  #              "* Commercial crew update https://arstechnica.com/science/2019/10/spacex-targeting-abort-test-late-this-year-crew-flight-soon-after/ https://spacenews.com/nasa-and-spacex-agree-commercial-crew-development-is-the-highest-priority/",
  #              "** Eric Berger says "full panic has ensued" https://twitter.com/SciGuySpace/status/1181572161917607948",
  #              "** Dragon done in 10 weeks? https://twitter.com/elonmusk/status/1181579173388673025\">twitter.com/elonmusk",
  #              "Short & Sweet",
  #              "* Virgin Orbit announces potential Martian cubesat missions. https://www.theverge.com/2019/10/9/20906657/virgin-orbit-mars-vehicle-deep-space-satellite-missions-launcherone-satrevolution?bxid=5d892338fc942d4788847f4d&amp;cndid=&amp;esrc=",
  #              "* Stratolaunch is now under new ownership. https://spacenews.com/stratolaunch-gets-mystery-new-owner/",
  #              "* The Jason-2 mission has ended, but its satellite will remain. https://spacenews.com/decommissioned-earth-science-satellite-to-remain-in-orbit-for-centuries"].join("\n")
  #   assert_equal @output, Episode.convert_markup_to_HTML(@string)
  # end

  # test "convert_markup_to_html format escapement for HTML" do
    # @string = [""].join("\n")
    # @output = [""].join("\n")
    # assert_equal @output, Episode.convert_markup_to_HTML(@string)
  # end


  # test "should get index" do
  #   get episodes_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get root_path
  #   assert_response :success
  # end

  # test "should create episode" do
  #   assert_difference('Episode.count') do
  #     post episodes_url, params: { episode: { description: @episode.description, notes: @episode.notes, number: @episode.number, publish_date: @episode.publish_date, slug: @episode.slug, title: @episode.title } }
  #   end

  #   assert_redirected_to episode_url(Episode.last)
  # end

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
