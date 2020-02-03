json.extract! episode, :id, :number, :title, :slug, :publish_date_short, :description, :notes, :created_at, :updated_at
json.url episode_url(episode, format: :json)
