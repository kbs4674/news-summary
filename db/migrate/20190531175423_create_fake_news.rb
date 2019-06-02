class CreateFakeNews < ActiveRecord::Migration[5.1]
  def change
    create_table :fake_news do |t|
      t.string :title
      t.string :content
      t.string :thumb_nail
      t.string :user_ip

      t.timestamps
    end
  end
end
