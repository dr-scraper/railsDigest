class CreateArticle < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.string :content, null: false
      t.string :summary, null: false, default: ""

      t.timestamps
    end
  end
end
