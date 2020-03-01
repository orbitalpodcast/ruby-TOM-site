require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-d", "--destroy", "Run verbosely") do |d|
    options[:destroy] = d
  end
end.parse!


episode_list = [
    {draft: false,
    newsletter_status: 'not sent', 
    number: 241,
    title: 'Clock Kerfuffle',
    slug: 'clock-kerfuffle',
    publish_date: '2019-12-24',
    description: 'Space software engineer and friend of the show Emory Stagmer joins us to discuss CST-100 Starliner\'s recent failure to rendezvous with ISS',
    notes: "Spaceflight news
          * Starliner OFT https://www.nasaspaceflight.com/2019/12/starliner-mission-shortening-failure-successful-launch/ http://www.collectspace.com/news/news-122219a-boeing-starliner-oft-landing.html
          ** IR video https://twitter.com/NASA/status/1208735543657320448
          ** Re-entry video from the ground https://twitter.com/MrTutskey/status/1208184010377170944
          Short & Sweet
          * Omega has a payload. https://www.spaceflightinsider.com/organizations/northrop-grumman/first-fight-of-omega-rocket-to-carry-ssn-payload/
          * ULA selected to launch next GOES mission. https://www.satellitetoday.com/government-military/2019/12/19/nasa-selects-ula-for-goes-t-mission/
          * SpaceX announces yet another Starlink launch. https://www.teslarati.com/spacex-starlink-internet-satellite-constellation-expands/
          This week in SF history
          * December 23, 1968. Apollo 8 enters Lunar SOI https://en.wikipedia.org/wiki/Apollo_8
          * Two weeks ahead in 2015: running out of juice"},
    {number: 240,
    title: 'Nightingale',
    slug: 'nightingale',
    publish_date: '2019-12-17',
    description: 'OSIRIS-Rex has set its sights on a crater called Nightingale, and will be headed down to grab some rocks from the surface of Asteroid Bennu in a year.',
    notes: "Spaceflight news
            * Rocket Lab inaugurates LC 2 at Wallops. https://spacenews.com/rocket-lab-inaugurates-u-s-launch-site/
            ** Reuse footage from Running Out of Fingers https://youtu.be/QK9mQdar5_w?t=1144
            * OSIRIS-Rex landing site selected https://spacenews.com/nasa-selects-osiris-rex-asteroid-sampling-site/
            Short & Sweet
            * A new European rocket gets funding. http://www.parabolicarc.com/2019/12/13/isar-aerospace-closes-17-million-series-a-for-new-launch-vehicle/#more-71645
            * SLS core stage is complete https://spacenews.com/sls-core-stage-declared-ready-for-launch-in-2021/
            * Vector files for chapter 11. https://spacenews.com/vector-files-for-chapter-11-bankruptcy/
            Questions, comments, corrections
            * Art in aerospace?
            This week in SF history
            * 18 December 1973: Launch of the Orion 2 space telescope onboard Soyuz 13 https://en.wikipedia.org/wiki/Soyuz_13 https://en.wikipedia.org/wiki/Orion_(space_telescope)"},
    {number: 239,
    title: 'DOWNLINK--Kyla Edison',
    slug: 'kyla-edison',
    publish_date: '2019-12-11',
    description: "Kyla Edison is a geologist working for PISCES, and she's sintering basalt into structural tiles for applications on Earth and off-world ISRU.",
    notes: "Sorry about the links not working! Squarespace knows about the issue, but still hasn’t fixed it. Visit theorbitalmechanics.com/show-notes/kyla-edison for links and photos! 
            Spaceflight news
            * First results from Parker Solar Probe! (nasa.gov) (nature.com)
            Short & Sweet
            * Running Out of Fingers successfully tests key elements of rocket reuse (techcrunch.com)
            * Huntsville gets a new solid rocket motor maker (rocket.com)
            Interview
            * Kyla Edison
            * Geology and Material Science Technician for PISCES Hawaii
            * (linkedin.com)
            * (pacificspacecenter.com)
            * (instagram.com/geolo_geek)
            This week in SF history
            * December 15, 1984: Launch of Vega 1 (wikipedia.org)
            * Balloon aerobot package (nssdc.gsfc.nasa.gov)
            * Structures and data article (articles.adsabs.harvard.edu)
            * Next week in 1973 - What’s the point of a space telescope with a lifetime of less than a week?"},
    {number: 238,
    title: 'Moon Prep',
    slug: 'moon-prep',
    publish_date: '2019-12-04',
    description: "SLS and Orion are making progress towards Artemis!",
    notes: "Sorry there are no links in this episode! Squarespace has broken that feature. Please visit theorbitalmechanics.com/show-notes/moon-prep for links and photos.

            Spaceflight news
            * RS-25 integration
            Short & Sweet
            * Orion capsule ships to Ohio for testing
            * Australian company 3D prints large rocket
            Questions, comments, corrections
            * Tempe meetup!
            ** 5 pm Sunday, December 8th
            ** tempe.laboccapizzeria.com
            ** S. Mill Ave, Tempe, AZ 85281
            This week in SF history
            * December 4, 1945, Birth of Roberta Bondar
            * Next week in 1984: What’s the point of a weather balloon with a sample rate of 75 seconds?"},
    {number: 237,
    title: 'DOWNLINK--Elena Zorzoli Rossi',
    slug: 'elena-zorzoli-rossi',
    publish_date: '2019-11-27',
    description: "We met Elena at IAC 2019. She\'s the lead experimental engineer at ThrustMe, and has been testing their new solid fuel electric propulsion engine!",
    notes: "Spaceflight news
            * Starship overpressure explosion https://spacenews.com/spacex-starship-suffers-testing-setback/
            ** Rumors on 4Chan, via Reddit and NSF forum https://www.reddit.com/r/SpaceXLounge/comments/e055ej/i_can_partially_end_the_speculation_about_why/
            Short & Sweet
            * Some insights into failed lunar landings have come out. https://spacenews.com/new-details-emerge-about-failed-lunar-landings/
            * Starliner rolls out. https://www.americaspace.com/2019/11/22/starliner-joins-rocket-for-dec-launch-on-uncrewed-orbital-flight-test/
            Questions, comments, corrections
            * Congrats to our Soonish giveaway winners!
            Interview
            * After the interview, Spacety reported a successful firing of I2T5! https://spacenews.com/spacety-thrustme-cold-gas-test/
            * Elena Zorzoli Rossi, lead experimental engineer, ThrustMe
            ** https://www.thrustme.fr/
            ** https://www.linkedin.com/company/thrustme.fr
            This week in SF history
            * November 28, 1964: Launch of Mariner 4 https://en.wikipedia.org/wiki/Mariner_4 https://www.jpl.nasa.gov/missions/mariner-4/
            * Next week in 1945: You were discussing critical space stuff with your pals the other dayyyyyyyy"},
    {number: 236,
    title: 'Panel Jettison',
    slug: 'pannel-jettison',
    publish_date: '2019-12-17',
    description: "This week we saw the beginning of a long series of EVAs to repair the Alpha Magnetic Spectrometer, which was not intended to be repaired on orbit.",
    notes: "Spaceflight news
            * Spacewalk to repair AMS https://spacenews.com/nasa-prepares-for-complex-series-of-spacewalks-to-repair-ams/ https://www.youtube.com/watch?v=37b2Z6J0zKc
            ** AMS overview https://www.nasa.gov/mission_pages/station/research/news/ams_how_it_works.html
            ** Footage from the EVA
            *** The cover is detached from the restraint clip https://youtu.be/evaBhht5uGA?t=13548
            *** Jettisoning the cover https://youtu.be/evaBhht5uGA?t=13604
            *** Chris Cassidy shows off a zip tie cutter/capture device https://youtu.be/evaBhht5uGA?t=17581
            Short & Sweet
            * Hayabusa2 departs Ryugu https://www.japantimes.co.jp/news/2019/11/13/national/science-health/japans-hayabusa2-leaves-asteroid
            * SpaceX completes Crew Dragon Static Fire tests https://spacenews.com/spacex-tests-crew-dragon-abort-thrusters/
            * Launcher gets funding from the Air Force. https://spacenews.com/launcher-af-pitch-award/
            Questions, comments, corrections
            * Win a book!
            ** Zach and Kelly Weinersmith wrote Soonish: Ten Emerging Technologies That'll Improve and/or Ruin Everything.
            ** We have signed copies to give away! In honor of the alternate first words featured on the new TV show For All Mankind, tweet at us with what your first words on Mars would be.
            ** Random winners selected from Twitter and email.
            * Episode 2 is missing!
            ** Do you have a copy of episode-2.mp3 lying around? Squarespace ate our copy!
            This week in SF history
            * November 19, 1956 Birth of Eileen Collins https://en.wikipedia.org/wiki/Eileen_Collins
            * Next week in 1964: The cold, dead 1%"},
    {number: 235,
    title: 'DOWNLINK--Andrew Rader',
    slug: 'andrew-rader',
    publish_date: '2019-11-12',
    description: "Andrew Rader is a mission manager at SpaceX, a game designer, a podcaster, and the author of many books, including his newest: Beyond the Known.",
    notes: "Spaceflight news
            * Starliner pad abort test complete https://spacenews.com/boeing-performs-starliner-pad-abort-test/ https://spaceflightnow.com/2019/11/07/boeing-identifies-cause-of-chute-malfunction-continues-preps-for-first-starliner-launch/
            ** Chute failure caused by misplaced pin https://www.americaspace.com/2019/11/09/boeing-discloses-cause-of-starliner-parachute-anomaly/ https://spacenews.com/missing-pin-blamed-for-boeing-pad-abort-parachute-anomaly/
            Short & Sweet
            * SpaceX’s Mark 3 parachutes are almost ready to go! https://spacenews.com/spacex-trumpets-progress-on-commercial-crew-parachute-testing/
            * China tests gridfins https://spacenews.com/china-tests-grid-fins-with-launch-of-gaofen-7-imaging-satellite/
            * The ISS may see reduced crew for 6 and a half months. https://spacenews.com/astronaut-preparing-for-iss-mission-with-reduced-crew/
            Interview: Andrew Rader, author, Beyond the Known
            * https://andrew-rader.com
            * https://twitter.com/marsrader
            * https://www.amazon.com/Beyond-Known-Exploration-Created-Modern/dp/1982123532
            This week in SF history
            * 15 November 1974 Launch of AMSAT-OSCAR 7 https://en.wikipedia.org/wiki/AMSAT-OSCAR_7 https://hackaday.com/2019/08/02/retrotechtacular-the-oscar-7-satellite-died-and-was-reborn-20-years-later/
            ** List of all OSCAR satellites https://en.wikipedia.org/wiki/AMSAT#Satellites_previously_launched_by_AMSAT
            * Next week in 1965: How about some nice lemon, gin and bob cut?"},
    {number: 234,
    title: 'Irregular Nomenclature',
    slug: 'irregular-nomenclature',
    publish_date: '2019-11-05',
    description: "Mitsubishi Heavy Industries\' H3 rocket will be a lunar powerhouse; we talk about newly released information about the rocket and JAXA\'s moon plans.",
    notes: "This week in SF history
            * 29 October 1998: Launch of STS-95 https://en.wikipedia.org/wiki/STS-95 https://www.nasa.gov/home/hqnews/presskit/1998/sts-95.pdf
            * Next week in 1974: Solidarity
            Spaceflight news
            * Upgraded H3 rocket for lunar missions https://spacenews.com/mitsubishi-heavy-industries-mulls-upgraded-h3-rocket-variants-for-lunar-missions/
            ** H-IIA had a proposed asymmetric configuration as well as liquid boosters (HT Sam in the chat: http://www.b14643.de/Spacerockets_1/Japan/H-IIA_Heavy/Description/Frame.htm)
            Short & Sweet
            * Chang’e-5 to launch late next year https://spacenews.com/china-targets-late-2020-for-lunar-sample-return-mission/
            * The X-37 sets another record. https://spacenews.com/air-force-x-37b-secret-spaceplane-lands-after-780-days-in-orbit/
            * NASA gives funding to look into extended mission to Pluto https://www.americaspace.com/2019/10/30/nasa-green-lights-study-for-orbital-mission-to-pluto/
            * Another plot twist for the mole on Mars. https://spacenews.com/insight-heat-flow-probe-suffers-setback/"},
    {title: 'IAC DC, 2019',
    publish_date: '2019-10-29',
    number: 233,
    slug: 'iac-dc-2019',
    notes: "Bit of a weird show this week! No news, tired hosts. We talk about our favorite things from this year’s International Astronautical Congress, and we promise more information later.
This show is brought to you by just over one hundred **supporters on Patreon** (and direct monthly supporters using Bitcoin and Paypal!) **We couldn’t have done this without you**, and we are so thankful for your confidence in our ability to bring you educational and entertaining content.",
    description: "This show is brought to you by just over one hundred supporters on Patreon. We couldn’t have done this without you, and we are so thankful for your confidence in our ability to bring you educational and entertaining content."},
    {publish_date: '2019-10-15',
    number: 232,
    title: 'Full Panic Ensued',
    slug: 'full-panic-ensued',
    notes: "This week in SF history
            * October 17, 1956: Birth of Mae Jemison https://en.wikipedia.org/wiki/Mae_Jemison
            Spaceflight news
            * Battery replacement EVAs https://www.americaspace.com/2019/10/07/spacewalkers-begin-three-week-eva-marathon-to-replace-space-station-batteries/
            * Commercial crew update https://arstechnica.com/science/2019/10/spacex-targeting-abort-test-late-this-year-crew-flight-soon-after/ https://spacenews.com/nasa-and-spacex-agree-commercial-crew-development-is-the-highest-priority/
            ** Eric Berger says *full panic has ensued* https://twitter.com/SciGuySpace/status/1181572161917607948
            ** Dragon done in 10 weeks? https://twitter.com/elonmusk/status/1181579173388673025
            Short & Sweet
            * Virgin Orbit announces potential Martian cubesat missions. https://www.theverge.com/2019/10/9/20906657/virgin-orbit-mars-vehicle-deep-space-satellite-missions-launcherone-satrevolution?bxid=5d892338fc942d4788847f4d&amp;cndid=&amp;esrc=
            * Stratolaunch is now under new ownership. https://spacenews.com/stratolaunch-gets-mystery-new-owner/
            * The Jason-2 mission has ended, but its satellite will remain. https://spacenews.com/decommissioned-earth-science-satellite-to-remain-in-orbit-for-centuries/",
    description: "Commercial Crew has fallen behind, but SpaceX is rushing to get Crew Dragon out the door."},
    {publish_date: '2019-10-8',
    number: 231 ,
    title: 'Fewer gyros, more problems',
    slug: 'fewer-gyros-more-problems',
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
            ** Friday: IAC no-ticket open day",
    description: "DSCOVR's safehold seems to be connected to a gryo, but there's a fix coming down the line."},
    {publish_date: '2019-10-01',
    number: 230,
    title: 'Starship InSight',
    slug: 'starship-insight',
    notes: "This week in SF history
            * October 1, 1958: NASA begins operations https://en.wikipedia.org/wiki/NASA#Creation https://www.archives.gov/global-pages/larger-image.html?i=/historical-docs/doc-content/images/natl-aero-space-act-1958-l.jpg&amp;c=/historical-docs/doc-content/images/natl-aero-space-act-1958.caption.html
            * Next week in 2000: Sometimes a good explosion is exactly what you need
            Spaceflight news
            * InSight scientists presents three new discoveries https://www.americaspace.com/2019/09/27/nasas-insight-lander-on-mars-discovers-odd-magnetic-pulses-and-water/ https://meetingorganizer.copernicus.org/EPSC-DPS2019/EPSC-DPS2019-336-2.pdf
            ** Images show scoop packing down regolith around mole? https://twitter.com/InSightImageBot/status/1178208165613244417
            * Starship update https://spacenews.com/spacex-to-update-starship-progress/ https://www.youtube.com/watch?v=cIQ36Kt7UVg https://spaceflightnow.com/2019/09/30/photos-spacexs-first-full-size-starship-prototype/
            ** Our interview with Tess Caswell on CDRA https://theorbitalmechanics.com/show-notes/tess-caswell
            Short & Sweet
            * NASA awards a long-term contract to Lockheed Martin. https://spacenews.com/nasa-awards-long-term-orion-production-contract-to-lockheed-martin/
            * Korea Pathfinder Lunar Orbiter delayed to 2022 https://spaceflightnow.com/2019/09/20/launch-of-south-korean-lunar-orbiter-delayed-to-2022/
            * NEO mission confirmed https://spacenews.com/nasa-to-develop-mission-to-search-for-near-earth-asteroids/",
    description: "Starship, headed to Mars one day, got shown off to the public. Insight, already on Mars, learned some interesting things about the magnetosphere."},
    {publish_date: '2019-09-24',
    number: 229,
    title: 'Somewhat Rectilinear',
    slug: 'somewhat-rectilinear',
    notes: "This week in SF history
            * September 27 2003: last flight of Ariane 5 G, launching E-Bird
            ** First A5 flight, 1996, failed spectacularly https://youtu.be/PK_yguLapgA?t=60 https://en.wikipedia.org/wiki/Cluster_(spacecraft) https://hownot2code.com/2016/09/02/a-space-error-370-million-for-an-integer-overflow/
            ** Next week in 1958: Twelve pages
            Spaceflight news
            * NASA planning on placing a cubesat in a Lunar near-rectilinear halo orbit https://spacenews.com/nasa-cubesat-to-test-lunar-gateway-orbit/ https://www.youtube.com/watch?v=X5O77OV9_ek
            ** Meanwhile some Congressfolk are suggesting killing Lunar Gateway altogether https://arstechnica.com/science/2019/09/some-nasa-contractors-appear-to-be-trying-to-kill-the-lunar-gateway/
            Short & Sweet
            * Updates on Rocket Lab and Blue Origin launch complexes https://www.rocketlabusa.com/news/updates/rocket-lab-readies-launch-complex-2-for-electron-launches-from-u-s-soil/ https://www.nasaspaceflight.com/2019/09/blue-origin-work-new-glenn-launch-facilities/
            * SpaceX is offering a buyout. https://www.space.com/spacex-starship-boca-chica-property-buyouts.html
            * Japan seeks to double its launch capacity. https://rocketrundown.com/japan-plans-to-double-orbital-launch-capacity-by-2020/
            Questions, comments, corrections
            * Off-Nominal DC (aka “inside the beltway”) meetup https://events.offnominal.space/",
    description: "NASA wants to put a cubesat in a near-rectilinear halo orbit. Also, lots of updates on private space launch facilities."},
    {publish_date: '2019-09-17',
    number: 228,
    title: 'Fired Up',
    slug: 'fired-up',
    notes: "This week in SF history
            * 21 September 1968: Landing of zond 5 https://en.wikipedia.org/wiki/Zond_5 http://www.russianspaceweb.com/zond5.html
            * Next week in 2003: generic no longer
            Spaceflight news
            * H-IIB launch pad fire https://www.youtube.com/watch?v=tI5u0x7toTU https://spacenews.com/launch-pad-fire-scrubs-japanese-iss-launch/ HT Sam in the chat: https://twitter.com/mageshiman1025/status/1171535119905017856
            * NASA conducts ground test of the B330. https://www.space.com/bigelow-aerospace-space-habitat-nasa-test.html
            ** Tour of B330 (Mars Transporter Testing Unit) and Olympus B2100 https://www.youtube.com/watch?v=BXLk4wWilpA
            Short & Sweet
            * Tianhe passes final review, though delays are still likely https://spacenews.com/chinese-space-station-core-module-passes-review-but-faces-delays/
            * NASA’s LRO to take images of the Vikram Lander https://spaceflightnow.com/2019/09/12/nasa-lunar-orbiter-to-image-chandrayaan-2-landing-site-next-week/
            Questions, comments, corrections
            * GOES-13 correction from Kevin Smith https://skyriddles.wordpress.com/2019/09/10/goes-13-gets-drafted/ https://spacenews.com/noaa-continues-weather-satellite-discussions-with-the-air-force/",
    description: "H-IIB had a literal fire lit under its butt, and more info about Bigelow's expandable space stations."},
    {publish_date: '2019-09-10',
    number: 227,
    title: "Successful Orbiter",
    slug: 'successful-orbiter',
    notes: "This week in SF history
            * 12 September 1959: Launch of Luna 2 https://en.wikipedia.org/wiki/Luna_2
            Spaceflight news
            * Chandrayaan-2’s successful orbiter mission? https://www.space.com/india-loses-contact-with-vikram-moon-lander-chandrayaan-2.html https://www.reddit.com/r/spaceflight/comments/d0fx3d/chandrayaan_2_vikram_lander_will_be_attempting/
            ** Doppler curves https://twitter.com/cgbassa/status/1170069055140765700
            ** Lander crash site located https://www.thehindu.com/news/national/chandrayaan-2-vikram-lander-located-on-lunar-surface-isro-chairman/article29367136.ece https://www.ndtv.com/india-news/efforts-to-make-contact-with-chandrayaan-2-lander-will-go-on-for-14-days-isro-chief-k-sivan-2097325
            ** Aeolus dodges a Starlink. https://www.space.com/spacex-starlink-esa-satellite-collision-avoidance.html
            Short & Sweet
            * Target marker operation and dress rehearsal postponed for Hayabusa2 http://www.hayabusa2.jaxa.jp/en/topics/20190903e_TM/
            * WFIRST passes PDR https://spacenews.com/wfirst-telescope-passes-preliminary-design-review/",
    description: "Chandrayaan-2's lander made it to the surface a little sooner than planned. Also, more Hayabusa2 news and WFIRST inches towards reality."},
    {publish_date: '2019-09-03',
    number: 226,
    title: 'Duricrust',
    slug: 'duricrust',
    notes: "This week in SF history
            * 7 September 1914: Birth of James Van Allen https://en.wikipedia.org/wiki/James_Van_Allen
            * Next week in 1962: cloud-based navigation
            Spaceflight news
            * Starhopper Completes Test Flight https://spacenews.com/spacexs-starhopper-completes-test-flight/
            ** Scott Manley’s excellent coverage https://www.youtube.com/watch?v=T29ybqjv8-U
            ** More detailed photos https://twitter.com/bocachicagal/status/1151851534533242880
            ** Updates from Elon Musk https://twitter.com/elonmusk/status/1166860032052539392
            * InSight mole update https://spacenews.com/insight-mission-seeking-new-ways-to-fix-heat-flow-probe/
            Short & Sweet
            * The completed Rosalind Franklin rover displayed by Airbus engineers! https://www.bbc.com/news/science-environment-49469225
            * Mars 2020 helicopter integrated into the rover https://www.bbc.com/news/science-environment-49512101
            * JWST has now been physically assembled https://www.nasa.gov/feature/goddard/2019/nasa-s-james-webb-space-telescope-has-been-assembled-for-the-first-time",
    description: "Insight is slowly getting closer to a successful mole deployment, and Starhopper showed off its stuff!"},
    {publish_date: '2019-08-27',
    number: 225,
    title: "DATA RELAY--Hot Structures",
    slug: 'hot-structure',
    notes: "This week in SF history
            * August 30, 1931. Birth of Jack Swigert https://en.wikipedia.org/wiki/Jack_Swigert
            * Next week in 1914: You know what might have killed Swigert….
            Spaceflight news
            * Uncrewed Soyuz aborts docking. https://spacenews.com/uncrewed-soyuz-aborts-iss-docking/
            ** Second attempt delayed to free up a new docking port. https://twitter.com/roscosmos/status/1165297078987317248
            Short & Sweet
            * Astrobotic chooses ULA’s Vulcan Centaur rocket to deliver its lunar lander https://www.astrobotic.com/2019/8/19/astrobotic-selects-united-launch-alliance-vulcan-centaur-rocket-to-launch-its-first-mission-to-the-moon
            * Sierra-Nevada selects ULA. https://spacenews.com/sierra-nevada-corp-selects-ula-vulcan-for-dream-chaser-missions/
            * Europa Clipper passes Key Decision Point-C https://arstechnica.com/science/2019/08/the-ambitious-europa-clipper-has-cleared-an-important-step-toward-flight/
            Data Relay -- Hot Structures
            * Thanks to Ben Crews for researching and presenting this topic! https://www.linkedin.com/in/ben-crews-966778101/
            * X-15 Hardware Design Challenges https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19910010760.pdf
            * NASA solicitation for research on hot structures https://www.sbir.gov/sbirsearch/detail/1547839
            * Multifunctional Hot Structure (HOST) Heat Shield https://www.techbriefs.com/component/content/article/tb/techbriefs/mechanics-and-machinery/27691
            * Heat Shield Concepts and Materials for Reentry Vehicles (includes some familiar lifting-body vehicle form proposals! https://apps.dtic.mil/dtic/tr/fulltext/u2/439449.pdf
            * Advances in Hot Structure Development https://ntrs.nasa.gov/search.jsp?R=20060020757
            * Thermal-Structural Optimization of Integrated Tanks for RLV https://arc.aiaa.org/doi/abs/10.2514/6.2004-1931
            * Tim Dodd’s discussion on Starship transpiration cooling https://www.youtube.com/watch?v=LogE40_wR9k
            * /u/spacerfirstclass speculates on Spaceship’s use of hot structures. https://www.reddit.com/r/spacex/comments/a4l6pp/the_new_design_is_metal_could_spacex_be_using/",
    description: "Why have a structure with a heat shield on top, when you could just make a structure that does both jobs?"},
    {publish_date: '2019-08-20',
    number: 224,
    title: 'Downward Vector',
    slug: 'downward-vector',
    notes: "This week in SF history
            * August 21, 1959. Little Joe 1 failure http://www-pao.ksc.nasa.gov/history/mercury/lj-1/lj-1.htm https://en.wikipedia.org/wiki/Little_Joe_1
            Spaceflight news
            * Linkspace hover test https://spacenews.com/chinese-linkspace-reaches-300-meters-with-launch-and-landing-test/
            * ESA confirms second Exomars parachute test has failed https://spacenews.com/esa-confirms-second-exomars-parachute-test-failure/
            * Vector Launch closes its doors https://spacenews.com/vector-replaces-ceo-amid-reports-of-financial-problems/ https://vector-launch.com/wp-content/uploads/2019/08/vector-statement.pdf
            Short & Sweet
            * OSIRIS-REx mission selects candidate sampling sites https://www.nasa.gov/press-release/nasa-mission-selects-final-four-site-candidates-for-asteroid-sample-return
            * Robonaut returns to Station. https://spacenews.com/robonaut-to-return-to-iss/
            * BEAM to stay on ISS https://spacenews.com/nasa-planning-to-keep-beam-module-on-iss-for-the-long-haul/
            * Virgin Galactic updates http://www.parabolicarc.com/2019/08/14/virgin-galactic-completes-wing-for-third-spaceshiptwo/ https://www.engadget.com/2019/08/15/virgin-galactic-spaceport-america-vms-eve/?guccounter=1
            Questions, comments, corrections
            * Come play an RPG with us! Friday August 30 at 5.30pm PT/8.30pm ET https://www.patreon.com/posts/rpg-night-28311838",
    description: "Linkspace successfully hovers, Exomars struggles with parachutes, and Vector Launch closes its doors."},
    {publish_date: '2019-08-14',
    number: 223,
    title: 'DOWNLINK--Ella Atkins',
    slug: 'ella-atkins',
    notes: "This week in SF history
            * August 17, 1962: Carl Sagan advocates for sterilizing spacecraft https://spacemedicineassociation.org/history1962/ https://www.pnas.org/content/pnas/46/4/396.full.pdf
            Spaceflight news
            * Rocketlab reuse https://spacenews.com/rocket-lab-to-attempt-to-reuse-electron-first-stage/ https://arstechnica.com/science/2019/08/heres-why-rocket-lab-changed-its-mind-on-reusable-launch/ https://www.youtube.com/watch?v=ZIaDWCK2Bmk
            Short & Sweet
            * First ion thruster use on a 1U cubesat https://spacenews.com/electric-thrusters-changed-attitude-of-university-wurzburg-cubesat/
            Interview-- Ella Atkins
            * Thanks to IEEE for arranging this interview! https://www.ieee.org/
            * Dr. Atkins’ profile and CV https://aero.engin.umich.edu/people/ella-atkins/
            * https://robotics.umich.edu/
            * https://www.aiaa.org/",
    description: "Ella Atkins is an aerospace engineering professor who has a rich history studying and designing automated systems in space and in the air."},
    {publish_date: '2019-08-06',
    number: 222,
    title: 'Heat Sunk',
    slug: 'heat-sunk',
    notes: "This week in SF history
            * 9 August 2005: Landing of STS-114 https://en.wikipedia.org/wiki/STS-114#6_August
            Spaceflight news
            * Cause of GOES-17 satellite issue identified by NOAA+NASA https://www.satellitetoday.com/imagery-and-sensing/2019/08/02/nasa-noaa-discover-cause-of-goes-17-issue https://www.nasa.gov/sites/default/files/atoms/files/goes-17_mib_releasable_summary_final.pdf
            ** Issue first publicly declared in May 2018 https://arstechnica.com/science/2018/05/newest-noaa-weather-satellite-suffers-critical-malfunction/
            ** GOES-West live data https://www.goes.noaa.gov/goes-w.html
            Short & Sweet
            * Elon Musk to give update on Starship in three weeks https://arstechnica.com/science/2019/08/elon-musk-will-update-the-status-of-starship-development-on-august-24/
            * OneWeb opens for production in Florida. https://www.spaceflightinsider.com/missions/commercial/oneweb-and-airbus-open-facility-for-mass-production-of-communication-satellites/
            * EDRS shows off its abilities. http://www.parabolicarc.com/2019/08/02/european-space-data-relay-system-shows-its-speed/",
    description: "A GOES malfunction has now been explained. We're gearing up to hear more about Starship. OneWeb is opening its doors, and EDRS is performing well."},
    {publish_date: '2019-07-30',
    number: 221,
    title: 'Soul Source',
    slug: 'soul-source',
    notes: "This week in SF history
            * 30 July 2008, first full firing of a Falcon 9 with all nine engines https://www.spacex.com/press/2012/12/19-1
            Spaceflight news
            * NASA issues rare sole source contract to NGIS https://spacenews.com/nasa-to-sole-source-gateway-habitation-module-to-northrop-grumman/ https://www.fbo.gov/index?s=opportunity&amp;mode=form&amp;tab=core&amp;id=36ebf3fc4d57c88b6bd8c94d1806dfb9&amp;_cview=0
            Short & Sweet
            * Starhopper hopped https://twitter.com/elonmusk/status/1155415096387969024 https://youtu.be/NCMpd7-Cp24?t=282
            * Blue Origin fires its BE-7 lunar lander engine https://www.geekwire.com/2019/one-step-moon-blue-origin-fires-7-lander-engine-full-6-minutes/
            * Lightsail-2 successfully deploys its sail and sends back imagery http://www.planetary.org/blogs/jason-davis/ls2-deploys-sail.html",
    description: "Northrop Grumman got a sole source contract to build a habitat module for the lunar gateway station."},
    {publish_date: '2019-07-24',
    number: 220,
    title: 'DOWNLINK--Ron Burkey',
    slug: 'ron-burkey',
    notes: "This week in SF history
            * 25 July 1962: Statement of work issued for LEM https://www.hq.nasa.gov/office/pao/History/SP-4009/v1p3d.htm
            Spaceflight news
            * Crew Dragon Explosion Conclusion https://www.spaceflightinsider.com/organizations/space-exploration-technologies/spacex-reveals-cause-of-crew-dragon-explosion/
            Short & Sweet
            * Eight key space observatories renewed https://www.nasa.gov/feature/nasa-extends-exploration-of-universe-for-eight-astrophysics-missions
            * Starhopper static fire https://www.nasaspaceflight.com/2019/07/spacex-resume-starhopper-tests/
            Interview-- Ron Burkey
            * Virtual AGC http://www.ibiblio.org/apollo/
            * Java port http://svtsim.com/moonjs/agc.html
            * Scanned original documents https://archive.org/details/virtualagcproject
            * Transcribed code https://github.com/virtualagc/virtualagc",
    description: "The Apollo Guidance Computer is famous, but the code it ran likely would have slipped into the fog of history if it wasn't for Ron Burkey's archives."},
    {publish_date: '2019-07-16',
    number: 219,
    title: 'Future Imperfect',
    slug: 'future-imperfect',
    notes: "This week in SF history
            * 18 July 1980: first successful launch of SLV, lofting Rohini RS-1 to orbit. https://en.wikipedia.org/wiki/Satellite_Launch_Vehicle
            Spaceflight news
            * Chandrayaan-2 summary http://www.planetary.org/blogs/guest-blogs/2019/chandrayaan-2-what-to-expect.html
            * InSight Lander’s heat probe is stuck. https://www.nasaspaceflight.com/2019/07/rescue-insight-landers-stuck-probe-underway/
            Short & Sweet
            * First Starhopper test hop coming up https://spacenews.com/spacex-preparing-for-first-starship-test-flight/
            * Firefly partners up to build a lunar lander. https://spacenews.com/firefly-to-partner-with-iai-on-lunar-lander/
            * Tiangong-2 is ready to deorbit. https://spacenews.com/china-set-to-carry-out-controlled-deorbiting-of-tiangong-2-space-lab/
            Questions, comments, corrections
            * RPG night scheduled! https://www.patreon.com/posts/rpg-night-28311838
            ** Friday August 30 at 5.30pm PT/8.30pm ET
            ** Same setting, new game! (Risus)",
    description: "India's headed to the Moon, though their launch was delayed after we recorded this episode."},
    {publish_date: '2019-06-10',
    number: 218,
    title: 'Low-flying Starlink',
    slug: 'low-flying-starlink',
    notes: "This week in SF history
            * 10 July, 1992: Giotto flies past 26P/Grigg-Skjellerup https://en.wikipedia.org/wiki/Giotto_(spacecraft)
            ** Ten instruments onboard https://www.nature.com/articles/321313a0
            ** Magnetometer experiment results http://articles.adsabs.harvard.edu/cgi-bin/nph-iarticle_query?1993A%26A...268L...5N&amp;amp;data_type=PDF_HIGH&amp;amp;whole_paper=YES&amp;amp;type=PRINTER&amp;amp;filetype=.pdf
            Spaceflight news
            * Orion Abort test is a success https://spacenews.com/orion-abort-system-passes-in-flight-abort-test/
            * Three Starlink satellites goes silent https://spacenews.com/contact-lost-with-three-starlink-satellites-other-57-healthy/
            ** Jeff Bezos files with FCC for Kuiper constellation https://www.geekwire.com/2019/amazon-asks-fcc-approval-project-kuiper-broadband-satellite-operation/
            Short & Sweet
            * ExoMars 2020 suffers parachute problem https://spacenews.com/european-mars-lander-suffers-parachute-damage-in-test/
            * DSCOVR is in safehold. https://spacenews.com/dscovr-spacecraft-in-safe-mode/
            Questions, comments, corrections
            * Andrew Zdanowicz via email: Dragonfly - why not a helicopter?",
    description: "Orion successfully abort, three Starlinks don\'t wake up, Exomars and DSCOVR get a little crash-y."},
    {publish_date: '2019-06-03',
    number: 217,
    title: 'Ms. Tree Snags the Fly!',
    slug: 'ms-tree-snags-the-fly',
    notes: "This week in SF history
            * July 2, 1952: birth of Linda Godwin https://en.wikipedia.org/wiki/Linda_M._Godwin
            ** STS-37 https://en.wikipedia.org/wiki/STS-37
            ** STS-59 https://en.wikipedia.org/wiki/STS-59
            ** STS-76 https://en.wikipedia.org/wiki/STS-76
            ** STS-108 https://en.wikipedia.org/wiki/STS-108
            Spaceflight news
            * Dragonfly http://www.planetary.org/blogs/jason-davis/nasa-greenlights-dragonfly.html https://www.americaspace.com/2019/06/27/nasas-dragonfly-mission-will-soar-the-skies-of-titan-in-search-of-lifes-origins/ https://spacenews.com/nasa-selects-titan-drone-for-next-new-frontiers-mission/ http://dragonfly.jhuapl.edu/News-and-Resources/docs/34_03-Lorenz.pdf
            * Falcon Heavy successfully flies STP-2 mission https://spacenews.com/spacex-to-demonstrate-falcon-heavy-capabilities-in-difficult-test-flight/ https://www.teslarati.com/spacex-surprise-falcon-heavy-booster-landing-distance-record/
            ** Center core TVC failure https://twitter.com/elonmusk/status/1143690145255841797
            ** Ms. Tree caught half a fairing https://twitter.com/Erdayastronaut/status/1143426488307462144
            Questions, comments, corrections
            * Help name the Mars 2020 rover! https://www.futureengineers.org/registration/judge/nametherover
            * https://twitter.com/hashtag/Mars2020
            * Clara Ma’s winning entry for Curiosity https://www.nasa.gov/mission_pages/msl/essay-20090527.html
            * https://twitter.com/call_him_bob",
    description: "Falcon Heavy had a TVC failure that resulted in the loss of another center core, but they finally caught a fairing. Also, Mars 2020 needs your help!"},
    {publish_date: '2019-05-26',
    number: 216,
    title: 'Look to Windward',
    slug: 'look-to-windward',
    notes: "This week in SF history
            * 28 June 1969. First flight of Black Arrow https://en.wikipedia.org/wiki/Black_Arrow
            Spaceflight news
            * Upcoming non-Earth science missions
            ** 2019
            *** Chandrayaan-2 https://en.wikipedia.org/wiki/Chandrayaan-2
            *** Spektr-RG https://en.wikipedia.org/wiki/Spektr-RG
            *** CHEOPS https://en.wikipedia.org/wiki/CHEOPS
            *** Chang’e 5 https://en.wikipedia.org/wiki/Chang%27e_5
            *** Lunar Scout / MX-1E https://en.wikipedia.org/wiki/Moon_Express
            ** 2020
            *** Solar Orbiter https://en.wikipedia.org/wiki/Solar_Orbiter
            *** PROBA-3 https://en.wikipedia.org/wiki/PROBA-3
            *** Aditya-L1 https://en.wikipedia.org/wiki/Aditya-L1
            *** Exomars https://en.wikipedia.org/wiki/Rosalind_Franklin_(rover) https://en.wikipedia.org/wiki/Kazachok
            *** Hope Mars Mission https://en.wikipedia.org/wiki/Hope_Mars_Mission
            *** Mars 2020 https://en.wikipedia.org/wiki/Mars_2020
            *** Korea Pathfinder Lunar Orbiter https://en.wikipedia.org/wiki/Korea_Pathfinder_Lunar_Orbiter
            ** 2021
            *** Astrobotic M1 https://en.wikipedia.org/wiki/Astrobotic_Technology#Lunar_missions
            *** Luna 25 https://en.wikipedia.org/wiki/Luna_25
            *** SLIM https://en.wikipedia.org/wiki/Smart_Lander_for_Investigating_Moon
            *** XRISM https://en.wikipedia.org/wiki/X-Ray_Imaging_and_Spectroscopy_Mission
            *** IXPE https://en.wikipedia.org/wiki/Imaging_X-ray_Polarimetry_Explorer
            *** JWST https://en.wikipedia.org/wiki/James_Webb_Space_Telescope
            *** Double Asteroid Redirection Test https://en.wikipedia.org/wiki/Double_Asteroid_Redirection_Test
            *** ASTER https://en.wikipedia.org/wiki/ASTER_(spacecraft)
            *** Lucy https://en.wikipedia.org/wiki/Lucy_(spacecraft)
            ** 2022
            *** PUNCH https://en.wikipedia.org/wiki/Polarimeter_to_Unify_the_Corona_and_Heliosphere
            *** EUCLID https://en.wikipedia.org/wiki/Euclid_(spacecraft)
            *** MOM 2 https://en.wikipedia.org/wiki/Mars_Orbiter_Mission_2
            *** TEREX https://en.wikipedia.org/wiki/Tera-hertz_Explorer
            *** DESTINY+ https://en.wikipedia.org/wiki/DESTINY%2B
            *** Psyche https://en.wikipedia.org/wiki/Psyche_(spacecraft)
            *** JUICE https://en.wikipedia.org/wiki/Jupiter_Icy_Moons_Explorer
            * Comet Interceptor mission approved https://spaceflightnow.com/2019/06/21/european-space-mission-to-get-close-up-view-of-new-comet/
            Short & Sweet
            * Stratolaunch is up for sale https://www.cnbc.com/2019/06/14/vulcan-selling-stratolaunch-worlds-largest-airplane-for-400-million.html
            * Firefly is offering free rides. https://spaceflightnow.com/2019/06/18/firefly-offering-free-launch-for-research-and-educational-payloads/
            * Worries raised about U.K. spaceport site in Scotland https://www.bbc.com/news/uk-scotland-highlands-islands-48667772
            Questions, comments, corrections
            * https://www.arahanga.space/",
    description: "While we wait out a slow news week, we look to the future and summarize upcoming non-Earth science missions."},
    {publish_date: '2019-05-18',
    number: 215,
    title: 'Shibboleth',
    slug: 'episode-215-shibboleth',
    notes: "This week in SF history
            * 22 June 1978. Discovery of Pluto’s moon Charon by John Christy https://en.wikipedia.org/wiki/Charon_(moon)
            Spaceflight news
            * Psyche review/preview https://spacenews.com/psyche-mission-clears-review/
            ** Just passed Key Decision Point C https://www.nasa.gov/sites/default/files/atoms/files/nasa_systems_engineering_handbook_0.pdf
            ** Multispectral Imager is based on MSL’s Mastcam, MAHLI, and MARDI https://www.hou.usra.edu/meetings/lpsc2016/pdf/1366.pdf
            ** Deep space laser communication demo https://en.wikipedia.org/wiki/Deep_Space_Optical_Communications
            Short & Sweet
            * India’s Chandrayaan-2 has launch date https://theprint.in/science/why-chandrayaan-2-is-isros-most-complex-mission-so-far/249252/
            * India has plans for its own space station. http://www.parabolicarc.com/2019/06/15/india-eyes-space-station-earth-orbit/
            * SOFIA improvements https://spacenews.com/nasa-to-adjust-sofia-operations-to-improve-productivity/
            Questions, comments, corrections
            * Valentin Frank: follow up on Tereshkova’s head injury
            * /u/MomoSapiensAD: Herschel mission time correction https://www.reddit.com/r/orbitalpodcast/comments/bzgcnq/episode_214_spitzering_nails/er0na11/
            * Apollo / Mariner / Viking / Voyager oral history https://twitter.com/jccwrt/status/1139384759719624706
            * Support the Rocket Cat fund! https://www.gofundme.com/f/rocket-cat-medical-fund",
    description: "Are you ready to visit the asteroid belt's metallic tooth? We sure are!"},
    {publish_date: '2019-05-11',
    number: 214,
    title: 'Spitzering Nails',
    slug: 'spitzering-nails',
    notes: "This week in SF history
            * 16 June 1963. Launch of Vostok 6 with Valentina Tereshkova https://en.wikipedia.org/wiki/Vostok_6
            Spaceflight news
            * Planned retirement of Spitzer https://spaceflightnow.com/2019/05/30/nasa-to-shut-down-spitzer-space-telescope-early-next-year/
            ** Final GO, launched in 2003 at ~1:30am https://boeing.mediaroom.com/2003-08-25-Last-of-NASAs-Great-Observatories-Launched-by-300th-Boeing-Delta-Rocket
            ** Private Funding https://spaceflightnow.com/2017/07/22/nasa-might-privatize-one-of-its-great-observatories/
            ** Iconic image of Andromeda Galaxy http://www.spitzer.caltech.edu/images/1493-ssc2005-20a1-Andromeda-in-the-Infrared
            ** Another iconic image, the Helix Nebula http://www.spitzer.caltech.edu/uploaded_files/other_files/0006/0551/NASA_HiddenUniverse_04.jpg
            Short & Sweet
            * ISS wants to go commercial https://spacenews.com/nasa-releases-iss-commercialization-plan/
            * NASA tries new strategy for stuck Martian instrument https://mars.nasa.gov/news/8445/insights-team-tries-new-strategy-to-help-the-mole/
            * China carries out a successful sea launch. https://spacenews.com/china-gains-new-flexible-launch-capabilities-with-first-sea-launch/",
    description: "Spitzer is being retired at long last. Also, a commercial ISS, an HP3 troubleshooting idea, and a launch from sea."}
]

if options[:destroy]
  puts "There are #{Episode.count} episodes loaded, but I'm DESTROYING THEM ALL!"
  Episode.destroy_all
else
  puts "There are #{Episode.count} episodes loaded."
  puts "The highest numbered episode is #{Episode.last.number}."
  puts "Creating lots of episodes, starting at 241."
end

for params in episode_list do
    Episode.create params.merge({draft: false, newsletter_status: 'not sent'})
end

231.times do |n|
    Episode.create(draft: false,
                  newsletter_status: 'not sent',
                  publish_date: '2019-10-22'.to_date + n*7,
                  number: 231-n,
                  title: "Generated Episode #{231-n}",
                  slug: "generated_episode_#{231-n}",
                  description: "Description goes up. Description goes down.",
                  notes: "Here are some notes!
                    This week in SF history
                    * A thing happened.
                    * A clue is also here.
                    Spaceflight News
                    * Here is an interesting news item.
                    * Here is another interesting news item.")
end

puts "There are now #{Episode.count} episodes in the db."
