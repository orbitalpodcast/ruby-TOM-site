require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase

  test "should not publish episode without any contents" do
    episode = Episode.new
    assert_not episode.save
  end


end
