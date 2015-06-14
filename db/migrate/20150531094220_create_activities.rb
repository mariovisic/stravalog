class CreateActivities < ActiveRecord::Migration
  def change
    enable_extension :hstore

    create_table :activities do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.hstore :strava_data, null: false
      t.string :slug, null: false
      t.integer :strava_activity_id, null: false

      t.timestamps null: false
    end

    add_index :activities, :slug, unique: true
    add_index :activities, :created_at
    add_index :activities, :strava_activity_id, unique: true
  end
end
