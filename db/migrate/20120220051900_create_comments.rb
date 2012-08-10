class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.references :entry
      t.references :user
      t.string :author_name
      t.string :author_email
      t.string :author_url
      t.string :author_ip
      t.string :comment_type
      t.boolean :approved

      t.timestamps
    end
    add_index :comments, :entry_id
    add_index :comments, :user_id
  end
end
