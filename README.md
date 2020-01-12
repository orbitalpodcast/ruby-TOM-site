# The Orbital Mechanics Podcast Rails Website Template

## Complaints
TOMcast used Squarespace for the first five years or so. It was pretty miserable. SS might be good for business or artist websites, but for people who publish regular content, and for podcasters in particular, the service leaves a lot to be desired. It's difficult to collaborate unless everyone working on the project can do the setup required to get their part of the job done, since there isn't a good templating system. Adding content in the same format over and over takes a lot of time to configure everything properly, and new features are occasionally added to the platform that just make our job harder. In addition, SS doesn't back up user content, and occansionally will lose or corrupt uploaded audio files with no way to recover them.

Yes, there are podcast-specific solutions out there, like Podbean, Libsyn and others. However, they don't provide a customizable front end, or much customization in general. They often don't solve the templating problem, and definitely don't provide a good conversion experience.

## The solution
> If you want something done, do it yourself!

-- Jean-Baptiste Emanuel Zorg

I built a laundry list of wants and desires, and tried to hire someone else to do the work for me. A fair price for the work turned out to be higher than I'd have liked, and ultimately, no one understands your needs as well as yourself, so I started this project. The intention is to build a multi-featured podcast platform that runs fast, is fully customizable, and overall solves all the problems above. This solution should not only provide for the needs of TOMcast, but also be extensible and easy enough to set up that it doesn't take much work for others to make use of it. Squarespace is stupid expensive! Save yourself some cash.

There are many CMS's that might do the trick. Originally, I planned to build this in Jekyll. However, ultimately, I wanted a browser-based front end with complex interpretive behaviors that would conform to my workflow, and I definitely did not want a static CMS that required local builds. While that's elegant, it's space consuming and harsh on cooperative work. Additionally, I wanted the freedom to later build in an integrated recurring support platform and webstore.

This repo is published under a CC BY-NC-SA 4.0 license, and you are welcome to modify and redistribute it to your heart's content. When I've finished building it, I'll be happy to help other podcasters understand, modify and utilize this code to build their own websites. At the moment, there is no protected front end, but there will eventually be front-end code that will not be available for re-use. **If you're interested in building that front end and/or a generic front end for others, please let me know! I will pay you. If you're interested in collaborating on the back end, feel free to get in touch! I'd love to have a co-author.**

## The Tour

(Much of this is in progress! This is as much a road map for me as a promise to you.)

#### Config/settings

If you're using the standard theme, updating this should be 90% of the work you need to do.

#### Index

Shows the most recent X number of episodes, links to static pages, and should be customized to display your social media posts, subscribe and support pages, etc. Right now, the homepage also acts as a dashboard for logged-in admins, showing drafted posts and scheduled tasks.

#### Static pages

Pretty boring, but important. Should be easy to customize for the MySpace crowd.

#### Episodes list and episode pages

The Episodes list shows a paginated list of all episodes and their descriptions. In addition, logged in admins see edit links. This list is not only more extensive than the index page, but also helps users find episodes that are most interesting to them. I'm considering a topic list, or some other discovery mechanism. This might be tied into a customizable RSS feed, but I'm not sure if I'm willing to dilute my iTunes ratings.

The individual episode pages display full notes, have an episode player, and photos. I might add a one-click feedback mechanism eventually that allows users to rate an episode or submit quick corrections.

Episodes that are drafts are not listed in the index and episodes list, and require user authentication to view.

#### Draft page

The TOM crew only works on one episode at a time. To cater to this workflow, if you navigate to TOM.com/draft, you will be asked to authenticate, then the episode edit page is brought up for either the current draft or a new draft if one isn't already in progress.

Episode objects have a number of attributes: an episode number, a title, a slug (for URLs), a publish date, a short description, longer notes with links, associations to multiple photo/caption objects, and an audio file. When an episode is published (ie saved with draft=false), all of these are validated. We want to make sure that podcast authors never publish an episode with something missing! However, saving as a draft skips a lot of validations, which means you can do work piecemeal. The one big issue here is that concurrent work will result in incomplete saves, overwriting each other's work. For TOMcast, that's not a problem due to our weekly schedules, but it might be a problem worth solving for other teams. Let me know if that's the case and we can collaborate on something.

I want to do as little work as possible getting new episodes up. Episode numbers are auto-filled, and slugs are generated from the episode title. Most importantly, the website knows how to use the data you've given it to build the RSS feed, to post on socials and email show notes in newsletter format. This is a major part of the magic: every other platform requires a lot of copy-pasting and entering the same data in multiple places. Instead, let's configure it to work for our specific workflow and requirements, then never touch it again.

The other bit of magic is the episode notes markup. WYSIWYG editors are wonderful if you're creating a whole new web page. For recurring tasks, though, they're slow and bulky. Instead, let's take a little time to learn a markup language and let the computer do the formatting for us. In this case, I've created the most minimal of markup languages. Assuming you'll usually have the same topic headers every show, we define those in the config file, and automatically format them as headers. Everything else gets bulleted. You can define sub-bullets with leading dashes. My particular preference is to use a pseudo-footnote format, where bullets are statements followed by a domain name in parentheses, hyperlinked to a source for the statement. To accomplish this in my minimalistic markup, just write a line and add a URL at the end. All of the following evaluate to the same output:

> Short & Sweet

> Omega has a payload. spaceflightinsider.com/organizations/northrop-grumman/first-fight-of-omega-rocket-to-carry-ssn-payload/

> ULA selected to launch next GOES mission. satellitetoday.com/government-military/2019/12/19/nasa-selects-ula-for-goes-t-mission/

#

> Short & Sweet

> Omega has a payload. (https://www.spaceflightinsider.com/organizations/northrop-grumman/first-fight-of-omega-rocket-to-carry-ssn-payload/)

> ULA selected to launch next GOES mission. (https://www.satellitetoday.com/government-military/2019/12/19/nasa-selects-ula-for-goes-t-mission/)

And that output is:

> Short & Sweet

> - Omega has a payload. ([spaceflightinsider.com](https://www.spaceflightinsider.com/organizations/northrop-grumman/first-fight-of-omega-rocket-to-carry-ssn-payload/))

> - ULA selected to launch next GOES mission. ([satellitetoday.com](https://www.satellitetoday.com/government-military/2019/12/19/nasa-selects-ula-for-goes-t-mission/))

#### RSS feeds

Conform to iTunes spec. Squarespace seems to think that only pushing out the 100 most recent episodes is a good idea, so I've gone ahead and done that, but also added an archive feed and a final RSS item that points users to it. In the future, secure, custom RSS feeds will be available to recurring supporters so they can have secure access to bonus content, either isolated or mixed in with all the other episodes.

#### Newsletter

Listeners can sign up to receive show notes, complete with links and photos, just before the episode is published. I encourage every educational podcast to include thorough links and references, but what's the point of doing so if most people listen to the show in their car, or while their hands are busy? Instead, we make that additional content available in their inboxes so they can either get a sneak peek before they listen to the show, or take their time clicking through links on topics that interested them when they're back at their desks.

Newsletter subscribers are actually user objects that will be integrated with the support back end.

#### Routing

config/routes.rb isn't increadibly readable, and has some weird setups to allow all of our old URLs generated by Squarespace to work. However, the flexibility offered by Rails should be helpful to everyone. Episodes get both a number (not necessarily the same as their database ID) and a slug, and can be accessed with either. In addition, an amount of link shortening is incorporated, so that all of the following URLs point to the same page, often without forwarding.

- TOM.com/214
- TOM.com/spitzering-nails
- TOM.com/episodes/214
- TOM.com/episodes/spitzering-nails
- TOM.com/show-notes/spitzering-nails
