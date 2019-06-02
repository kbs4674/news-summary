class CreateNews < ActiveRecord::Migration[5.1]
  def change
    create_table :news do |t|
      t.string :title
      t.string :category
      t.text :content
      t.string :thumb_nail
      t.string :news_url

      t.timestamps
    end
  end
end
