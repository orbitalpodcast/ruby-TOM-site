xml.instruct! :xml, :version => "1.0"
xml.rss "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", :version => "2.0" do
  xml.channel do
    xml.title Settings.rss.title
    xml.link episodes_url
    xml.lastBuildDate Time.zone.now.to_s(:rfc822)
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
    xml.link root_path

    @episodes.each do |episode|
      xml.item do
        xml.title episode.title
        # xml.enclosure :url => episode.audio_file, :length => episode.audio_file.length, :type => 'audio/mp3'
        xml.pubDate episode.publish_date.to_s(:rfc822)
        xml.description episode.description
        xml.link episode_url(episode)
        xml.guid episode_url(episode)
        # IF WE WANT TO FORMAT SPECIFIC IMAGES FOR EACH EPISODE, USE xml.itunes :image, asdf
        xml.itunes :explicit, 'no'
      end
    end
  end
end



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