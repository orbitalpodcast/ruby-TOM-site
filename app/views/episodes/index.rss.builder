# https://help.apple.com/itc/podcasts_connect/#/itcb54353390

xml.instruct! :xml, :version => "1.0"
xml.rss "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", :version => "2.0" do
  xml.channel do
    xml.title Settings.rss.title
    xml.link episodes_url
    xml.lastBuildDate Episode.order(:publish_date).last.publish_date.to_s(:rfc822)
    xml.language Settings.rss.language
    xml.itunes :author, Settings.rss.author
    xml.itunes :explicit, Settings.rss.explicit_show
    xml.itunes :owner do
      xml.itunes :name, Settings.rss.owner.my_name
      xml.itunes :email, Settings.rss.owner.email
    end
    for category, subcategory in Settings.rss.category do
      xml.itunes :category, :text => category do
        xml.itunes :category, :text => subcategory
      end
    end
    xml.itunes :type, Settings.rss.type
    xml.itunes :image, Settings.rss.image_show
    xml.description Settings.rss.description_show

    @rss_episodes.each do |episode|
      xml.item do
        xml.title episode.full_title
        # xml.enclosure :url => episode.audio_file, :length => episode.audio_file.length, :type => 'audio/mp3'
        xml.guid episode_url(episode) # TODO: implement RSS GUID override for episodes still on the Squarespace feed at publish time. Include isPermaLink="false" when overriding
        xml.pubDate episode.publish_date.to_s(:rfc822)
        xml.description episode.description
        # xml.itunes :duration, episode.audio_file.length
        xml.link episode_url(episode)
        # IF WE WANT TO FORMAT SPECIFIC IMAGES FOR EACH EPISODE, USE xml.itunes :image, image_path
              # Artwork must be a minimum size of 1400 x 1400 pixels and a maximum size of 3000 x 3000 pixels,
              # in JPEG or PNG format, 72 dpi, with appropriate file extensions (.jpg, .png), and in the RGB colorspace.
              # These requirements are different from the standard RSS image tag specifications.
        xml.itunes :explicit, 'no'
        xml.content :encoded do
          xml.cdata! episode.notes
        end
      end
    end
  end
end

# TODO: add syndication schedule http://web.resource.org/rss/1.0/modules/syndication/

# SQUARESPACE OUTPUT
# <item>
#     <title>Episode 240: Nightingale</title>
#     <category>Episode</category>
#     <dc:creator>Ben Etherington</dc:creator>
#     <pubDate>Tue, 17 Dec 2019 23:23:55 +0000</pubDate>
#     <link>https://theorbitalmechanics.com/show-notes/nightingale</link>
#     <guid isPermaLink="false">5439a3d0e4b0dedc218f23b9:5443f8fce4b0566007c13332:5df840859bc7dc323ff00950</guid>
#     <description>
#       <![CDATA[
#       ]]>
#     </description>
#     <content:encoded>
#       <![CDATA[
#       ]]>
#     </content:encoded>
#     <itunes:author>The Orbital Mechanics</itunes:author>
#     <itunes:subtitle>OSIRIS-Rex has set its sights on a crater called Nightingale, and will be headed down to grab some rocks from the surface of Asteroid Bennu in a year.</itunes:subtitle>
#     <itunes:summary>OSIRIS-Rex has set its sights on a crater called Nightingale, and will be headed down to grab some rocks from the surface of Asteroid Bennu in a year.</itunes:summary>
#     <itunes:explicit>no</itunes:explicit>
#     <itunes:duration>00:27:51</itunes:duration>
#     <itunes:image href="https://static1.squarespace.com/static/5439a3d0e4b0dedc218f23b9/5443f8fce4b0566007c13332/5df840859bc7dc323ff00950/1576624977501/1500w/Nightingale.png"/>
#     <itunes:title>Episode 240: Nightingale</itunes:title>
#     <enclosure url="https://static1.squarespace.com/static/5439a3d0e4b0dedc218f23b9/t/5df962d7a48e88085265ddd2/1576624889548/Episode-240.mp3" length="23390429" type="audio/mpeg"/>
#     <media:content url="https://static1.squarespace.com/static/5439a3d0e4b0dedc218f23b9/t/5df962d7a48e88085265ddd2/1576624889548/Episode-240.mp3" length="23390429" type="audio/mpeg" isDefault="true" medium="audio">
#       <media:title type="plain">Episode 240: Nightingale</media:title>
#     </media:content>
#   </item>

# THIS CODE OUTPUT
# <item>
#   <title>Episode 240: Nightingale</title>
#   <guid>http://127.0.0.1:3000/episodes/nightingale</guid>
#   <pubDate>17 Dec 2019</pubDate>
#   <description>OSIRIS-Rex has set its sights on a crater called Nightingale, and will be headed down to grab some rocks from the surface of Asteroid Bennu in a year.</description>
#   <link>http://127.0.0.1:3000/episodes/nightingale</link>
#   <itunes:explicit>no</itunes:explicit>
#   <content:encoded>
#     <![CDATA[<p class="">Spaceflight news</p><p class="">— Rocket Lab inaugurates LC 2 at Wallops. (<a href="https://spacenews.com/rocket-lab-inaugurates-u-s-launch-site/">spacenews.com</a>)</p><p class="">    — Reuse footage from Running Out of Fingers (<a href="https://youtu.be/QK9mQdar5_w?t=1144">youtu.be</a>)</p><p class="">— OSIRIS-Rex landing site selected (<a href="https://spacenews.com/nasa-selects-osiris-rex-asteroid-sampling-site/">spacenews.com</a>)</p><p class="">Short &amp; Sweet</p><p class="">— A new European rocket gets funding. (<a href="http://www.parabolicarc.com/2019/12/13/isar-aerospace-closes-17-million-series-a-for-new-launch-vehicle/#more-71645">parabolicarc.com</a>)</p><p class="">— SLS core stage is complete (<a href="https://spacenews.com/sls-core-stage-declared-ready-for-launch-in-2021/">spacenews.com</a>)</p><p class="">— Vector files for chapter 11. (<a href="https://spacenews.com/vector-files-for-chapter-11-bankruptcy/">spacenews.com</a>)</p><p class="">Questions, comments, corrections</p><p class="">— Art in aerospace?</p><p class="">This week in SF history</p><p class="">— 18 December 1973: Launch of the Orion 2 space telescope onboard Soyuz 13 (<a href="https://en.wikipedia.org/wiki/Soyuz_13">wikipedia.org</a>) (<a href="https://en.wikipedia.org/wiki/Orion_(space_telescope)">wikipedia.org</a>)</p>]]>
#   </content:encoded>
# </item>