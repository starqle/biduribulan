class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name, :null => false
      t.integer :entry_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.string :title
      t.text :content
      t.references :user
      t.text :excerpt
      t.string :status
      t.string :comment_status
      t.string :guid
      t.integer :menu_order
      t.string :entry_type
      t.string :mime_type
      t.datetime :published_at
      
      # required for paperclip
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
    add_index :entries, :user_id
    add_index :entries, :name, :unique => true
  end
end
