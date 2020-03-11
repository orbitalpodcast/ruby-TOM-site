require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase

  ep_params = {draft: false,
              newsletter_status: :not_sent,
              publish_date: '2020-01-07',
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

  test "should validate episode with missing draft and default to true" do
    episode = Episode.new(ep_params.except(:draft))
    assert episode.save
    assert episode.draft?
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