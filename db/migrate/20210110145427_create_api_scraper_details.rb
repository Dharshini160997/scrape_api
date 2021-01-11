class CreateApiScraperDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :api_scraper_details do |t|
      t.string :api
      t.text :details
      t.timestamps
    end
  end
end
