episodes
  have a draft bool
  have a number int
  have a title string
  have a slug string
  might have a publish date
  have a description string
  have a notes string
  might have multiple photos
  can derrive an MP3 URL

photos
  belong to an episode
  have a filename?
  have a caption string
  might have a source string
  have a featured bool
    validate only one featured per episode

listeners
  have a name string
  have an email string



index
  X most recent episodes
    featured image
    title, linked to episode page
    publish date
    description
  episode search bar
  Navbar, announcements, welcome text etc.

Episodes
  paginated episodes, sorted by descending publish date
    title, linked to episode page
    publish date
    description
    when author logged in, edit

Drafts
  If only one draft, redirects to that draft.
  If more than one draft, lists all drafts.

Episode
  Title
  publish date
  player
  notes
  photos
    photo
    description
    source
  when author logged in
    edit
    emergency un-publish
      save draft true, open edit page

Draft
  Edit episode (not show!)
  Draft save
    Saves draft, ignores validations, no other actions
  Draft and mailer
    Saves draft, applies validations other than MP3
    Opens preview with a confirm button
      Return to draft
      Confirm send
  Publish
    Saves not draft, applies all validations
    Sends tweet
    Sends reddit post

Routing
  TOM.com                   => index
  tom.com/episodes          => episodes
  tom.com/123               => episode slug
  tom.com/slug              => episode slug
  tom.com/show-notes/slug   => episode slug