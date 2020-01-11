class EpisodeMailer < ApplicationMailer

  def show_notes(episode)
    @episode = episode
    @recipients = User.where(subscribed: true)
    # @emails = @recipients.collect(&:email).join(",")
    @subject = "🎧 Episode #{@episode.number}: #{@episode.title}"

    for recipient in @recipients do
      @user = recipient
      mail(to: recipient.email, subject: @subject)
    end
  end

end
