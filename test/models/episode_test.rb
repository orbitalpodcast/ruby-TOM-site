require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase

  ep_params = {draft: false,
  newsletter_status: 'not sent',
  publish_date: '2019-10-8',
  number: 231 ,
  title: 'Fewer gyros, more problems',
  slug: 'fewer-gyros-more-problems',
  description: "DSCOVR's safehold seems to be connected to a gryo, but there's a fix coming down the line.",
  notes: "This week in SF history
          * 2000 October 9: HETE-2, first orbital launch from Kwajalein https://en.wikipedia.org/wiki/High_Energy_Transient_Explorer
          * Next week in 1956: listen in for an audio clue.
          Spaceflight news
          * Plans in place to fix DSCOVR https://spacenews.com/software-fix-planned-to-restore-dscovr/
          ** We first reported on this on https://docs.google.com/document/d/1RAydcXcHFi7QiPkSLhdxuc-ILNNSTZwJGbsqpnabcdg/edit Ep 218 as a S&S https://spacenews.com/dscovr-spacecraft-in-safe-mode/
          ** Faulty gyro? https://twitter.com/simoncarn/status/1175823150984126464
          *** Triana engineers considered laser gyro failures https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/20010084979.pdf
          Short & Sweet
          * NASA Mars 2020 tests descent stage separation https://www.jpl.nasa.gov/news/news.php?feature=7513
          * NASA issues request for information on xEMU. https://www.nasaspaceflight.com/2019/10/nasa-rfi-new-lunar-spacesuits/
          * New Shepard will likely not fly humans in 2019. https://spacenews.com/blue-origin-may-miss-goal-of-crewed-suborbital-flights-in-2019/
          Questions, comments, corrections
          * https://twitter.com/search?q=%23tomiac2019&amp;f=live
          ** Sunday: Off Nominal meetups https://events.offnominal.space/
          ** Monday: museum day
          *** Udvar-Hazy and downtown Air and Space Museum
          ** Thursday: Dinner meetup
          *** https://www.mcgintyspublichouse.com/
          *** 911 Ellsworth Dr, Silver Spring, MD 20910
          ** Friday: IAC no-ticket open day"}
   
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