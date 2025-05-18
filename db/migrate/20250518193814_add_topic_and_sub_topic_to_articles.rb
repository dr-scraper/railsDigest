class AddTopicAndSubTopicToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :topic, :string
    add_column :articles, :subtopic, :string
  end
end
