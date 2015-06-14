class CreateActivities < ActiveRecord::Migration
  def change
    enable_extension :hstore

    create_table :activities do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.hstore :strava_data, null: false
      t.string :slug, null: false

      t.timestamps null: false
    end

    add_index :activities, :slug, unique: true
  end
end
