class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text
      t.belongs_to :user
      t.timestamps
    end
  end
end
