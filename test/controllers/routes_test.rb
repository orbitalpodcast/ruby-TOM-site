require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  test "generate episode paths" do
    assert_generates "/episodes",     controller: 'episodes', action: 'index'
    assert_generates "/episodes.rss", controller: 'episodes', action: 'index', format: 'rss'
    assert_generates "/episodes",     controller: 'episodes', action: 'index'
    assert_generates "/draft",        controller: 'episodes', action: 'draft'

    assert_generates "episodes/clock-kerfuffle", { controller: 'episodes', action: 'show', id: "clock-kerfuffle" }
  end

  test "route episode paths" do
    # index pagination
    assert_recognizes({controller: 'episodes', action: 'index', begin: episodes(:one).number.to_s, end: episodes(:five).number.to_s},
                      {path:"/episodes/#{episodes(:one).number}/to/#{episodes(:five).number}", method: :get})

    # /slug and /number redirects
    get "/#{episodes(:one).number}"
    assert_redirected_to "/episodes/#{episodes(:one).number}"
    get "/#{episodes(:one).slug}"
    assert_redirected_to "/episodes/#{episodes(:one).slug}"

    # episode show
    assert_recognizes({controller: 'episodes', action: 'show', id: episodes(:one).number.to_s},
                      {path:"/episodes/#{episodes(:one).number}", method: :get})
    assert_recognizes({controller: 'episodes', action: 'show', id: episodes(:one).slug},
                      {path:"/episodes/#{episodes(:one).slug}", method: :get})

    # legacy URLs
    get "/show-notes/2019/12/24/#{episodes(:one).slug}"
    assert_redirected_to "/episodes/#{episodes(:one).slug}"
    get "/show-notes/#{episodes(:one).slug}"
    assert_redirected_to "/episodes/#{episodes(:one).slug}"
  end

end
