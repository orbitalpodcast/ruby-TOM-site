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

  test "convert_markup_to_html handle headers and alternates" do
    @string = ["Short & Sweet",
               "Spaceflight News",
               "questions, comments, corrections"].join("\n")
    @output = ["<h3>Short & Sweet</h3>",
               "<h3>Spaceflight News</h3>",
               "<h3>Questions, Comments and Correction Burns</h3>"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  # test "convert_markup_to_html format in-line links" do
    # @string = [""].join("\n")
    # @output = [""].join("\n")
    # assert_equal @output, Episode.convert_markup_to_HTML(@string)
  # end

  # test "convert_markup_to_html format bold and itallics" do
    # @string = [""].join("\n")
    # @output = [""].join("\n")
    # assert_equal @output, Episode.convert_markup_to_HTML(@string)
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
