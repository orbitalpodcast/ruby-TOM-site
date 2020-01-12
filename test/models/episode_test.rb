require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase

  ep_params = {draft: false,
      newsletter_status: 'scheduled',
      number: 237,
      title: 'DOWNLINK--Elena Zorzoli Rossi',
      slug: 'elena-zorzoli-rossi',
      publish_date: '2019-11-27',
      description: "We met Elena at IAC 2019. She\'s the lead experimental engineer at ThrustMe, and has been testing their new solid fuel electric propulsion engine!",
      notes: "Spaceflight news
      * Starship overpressure explosion https://spacenews.com/spacex-starship-suffers-testing-setback
      * Rumors on 4Chan, via Reddit and NSF forum https://www.reddit.com/r/SpaceXLounge/comments/e055ej/i_can_partially_end_the_speculation_about_why/ https://forum.nasaspaceflight.com/index.php?topic=49114.1540
      Short & Sweet
      * Some insights into failed lunar landings have come out. https://spacenews.com/new-details-emerge-about-failed-lunar-landings/
      * Starliner rolls out. https://www.americaspace.com/2019/11/22/starliner-joins-rocket-for-dec-launch-on-uncrewed-orbital-flight-test/
      Questions, comments, corrections
      * Congrats to our Soonish giveaway winners!
      Interview
      * After the interview, Spacety reported a successful firing of I2T5! https://spacenews.com/spacety-thrustme-cold-gas-test/
      * Elena Zorzoli Rossi, lead experimental engineer, ThrustMe
      * https://www.thrustme.fr/
      * https://www.linkedin.com/company/thrustme.fr
      This week in SF history
      * November 28, 1964: Launch of Mariner 4 https://en.wikipedia.org/wiki/Mariner_4 https://www.jpl.nasa.gov/missions/mariner-4/
      * Next week in 1945: You were discussing critical space stuff with your pals the other dayyyyyyyy"}
   
  test "should save valid episode" do
    episode = Episode.new(ep_params)
    assert episode.save
  end

  test "should not validate episode without any contents" do
    episode = Episode.new()
    assert_not episode.save
  end

  test "should not validate episode without a number" do
    episode = Episode.new(ep_params.except(:number))
    assert_not episode.save
  end

  test "should not validate episode without unique number" do
    episode = Episode.new(ep_params)
    episode[:number] = episodes(:one).number
    assert_not episode.save
  end

  test "should not validate episode with a string as an episode number" do
    episode = Episode.new(ep_params)
    episode[:number] = 'two hundred thirty seven'
    assert_not episode.save
  end

  test "should not validate episode without a slug" do
    episode = Episode.new(ep_params.except(:slug))
    assert_not episode.save
  end

  test "should not validate episode without unique slug" do
    episode = Episode.new(ep_params)
    episode[:slug] = episodes(:one).slug
    assert_not episode.save
  end

  test "should not validate episode with a short slug" do
    episode = Episode.new(ep_params)
    episode[:slug] = 'cloc'
    assert_not episode.save
  end

  test "should not validate episode with a placeholder slug" do
    episode = Episode.new(ep_params)
    episode[:slug] = 'untitled-draft'
    assert_not episode.save
  end

  test "should not validate episode with missing draft" do
    episode = Episode.new(ep_params.except(:draft))
    assert_not episode.save
  end

  test "should not validate episode with missing draft (from empty string)" do
    episode = Episode.new(ep_params)
    episode[:draft] = ''
    assert_not episode.save
  end

  test "should not validate episode with missing title" do
    episode = Episode.new(ep_params.except(:title))
    assert_not episode.save
  end

  test "should not validate episode without unique title" do
    episode = Episode.new(episode)
    episode[:title] = episodes(:one).title
    assert_not episode.save
  end

  test "should not validate episode without unique title and should be case insensitive" do
    episode = Episode.new(ep_params)
    episode[:title] = episodes(:one).title.downcase
    assert_not episode.save
  end

  test "should not validate episode with a short title" do
    episode = Episode.new(ep_params)
    episode[:title] = 'cloc'
    assert_not episode.save
  end

  test "should not validate episode with missing publish date" do
    episode = Episode.new(ep_params.except(:publish_date))
    assert_not episode.save
  end

  test "should not validate episode with missing description" do
    episode = Episode.new(ep_params.except(:description))
    assert_not episode.save
  end

  test "should not validate episode with missing notes" do
    episode = Episode.new(ep_params.except(:notes))
    assert_not episode.save
  end



end