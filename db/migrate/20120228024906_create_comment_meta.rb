class CreateCommentMeta < ActiveRecord::Migration
  def change
    create_table :comment_meta do |t|
      t.references :comment
      t.string :key
      t.text :value

      t.timestamps
    end
    add_index :comment_meta, :comment_id
  end
end
