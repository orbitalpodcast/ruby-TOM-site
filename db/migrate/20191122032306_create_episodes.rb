class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.integer  :number,               index: {unique: true}
      t.string   :slug,                 index: {unique: true}
      t.boolean  :draft,                default: true
      t.string   :newsletter_status,    default: 'not scheduled'
      t.integer  :newsletter_job_id
      t.boolean  :ever_been_published
      t.string   :title
      t.datetime :publish_date
      t.string   :description
      t.string   :notes
      t.string   :reddit_url
      t.string   :twitter_url

      t.timestamps
    end
  end
end
