require 'test_helper'

class EpisodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @episode = episodes(:one)
  end

  test "convert_markup_to_html format URLs, accounting for twitter usernames" do
    @string = ["Spaceflight News",
               "Starliner OFT https://www.nasaspaceflight.com/2019/12/starliner-mission-shortening-failure-successful-launch/ http://www.collectspace.com/news/news-122219a-boeing-starliner-oft-landing.html",
               "IR video https://twitter.com/NASA/status/1208735543657320448"].join("\n")
    @output = ["Spaceflight News",
               "Starliner OFT (<a href=\"https://www.nasaspaceflight.com/2019/12/starliner-mission-shortening-failure-successful-launch/\">nasaspaceflight.com</a>) (<a href=\"http://www.collectspace.com/news/news-122219a-boeing-starliner-oft-landing.html\">collectspace.com</a>)",
               "IR video (<a href=\"https://twitter.com/NASA/status/1208735543657320448\">twitter.com/NASA</a>)"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format URLs, accounting for subreddits and forums" do
    @string = ["Spaceflight News",
               "* Starship overpressure explosion https://spacenews.com/spacex-starship-suffers-testing-setback/",
               "** Rumors on 4Chan, via Reddit and NSF forum https://www.reddit.com/r/SpaceXLounge/comments/e055ej/i_can_partially_end_the_speculation_about_why/ https://forum.nasaspaceflight.com/index.php?topic=49114.1540"].join("\n")
    @output = ["Spaceflight News",
               "* Starship overpressure explosion (<a href=\"https://spacenews.com/spacex-starship-suffers-testing-setback/\">spacenews.com</a>)",
               "** Rumors on 4Chan, via Reddit and NSF forum (<a href=\"https://www.reddit.com/r/SpaceXLounge/comments/e055ej/i_can_partially_end_the_speculation_about_why/\">/r/SpaceXLounge</a>) (<a href=\"https://forum.nasaspaceflight.com/index.php?topic=49114.1540\">forum.nasaspaceflight.com</a>)"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format URLs, accounting for file type" do
    @string = ["This week in SF history",
               "* 29 October 1998: Launch of STS-95 https://en.wikipedia.org/wiki/STS-95 https://www.nasa.gov/home/hqnews/presskit/1998/sts-95.pdf",
               "* Next week in 1974: Solidarity"].join("\n")
    @output = ["This week in SF history",
               "* 29 October 1998: Launch of STS-95 (<a href=\"https://en.wikipedia.org/wiki/STS-95\">en.wikipedia.org</a>) (PDF: <a href=\"https://www.nasa.gov/home/hqnews/presskit/1998/sts-95.pdf\">nasa.gov</a>)",
               "* Next week in 1974: Solidarity"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format URLs, accounting for existing parens with no spaces" do
    @string = ["This week in SF history",
               "* 29 October 1998: Launch of STS-95 (https://en.wikipedia.org/wiki/STS-95)",
               "* Next week in 1974: Solidarity"].join("\n")
    @output = ["This week in SF history",
               "* 29 October 1998: Launch of STS-95 (<a href=\"https://en.wikipedia.org/wiki/STS-95\">en.wikipedia.org</a>)",
               "* Next week in 1974: Solidarity"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  test "convert_markup_to_html format URLs, accounting for existing parens with padding spaces" do
    @string = ["This week in SF history",
               "* 29 October 1998: Launch of STS-95 (   http://foo.com/blah_blah_(wikipedia)_(again))",
               "* 29 October 1998: Launch of STS-95 (http://foo.com/blah_blah_(wikipedia)_(again)   )",
               "* 29 October 1998: Launch of STS-95 (   http://foo.com/blah_blah_(wikipedia)_(again) )",
               "* Next week in 1974: Solidarity"].join("\n")
    @output = ["This week in SF history",
               "* 29 October 1998: Launch of STS-95 (<a href=\"http://foo.com/blah_blah_(wikipedia)_(again)\">foo.com</a>)",
               "* 29 October 1998: Launch of STS-95 (<a href=\"http://foo.com/blah_blah_(wikipedia)_(again)\">foo.com</a>)",
               "* 29 October 1998: Launch of STS-95 (<a href=\"http://foo.com/blah_blah_(wikipedia)_(again)\">foo.com</a>)",
               "* Next week in 1974: Solidarity"].join("\n")
    assert_equal @output, Episode.convert_markup_to_HTML(@string)
  end

  # test "convert_markup_to_html format URLs, accounting for hat tips" do
    # @string = [""].join("\n")
    # @output = [""].join("\n")
    # assert_equal @output, Episode.convert_markup_to_HTML(@string)
  # end

  # test "convert_markup_to_html format URLs, allowing escaped full URLs" do
    # @string = [""].join("\n")
    # @output = [""].join("\n")
    # assert_equal @output, Episode.convert_markup_to_HTML(@string)
  # end

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
