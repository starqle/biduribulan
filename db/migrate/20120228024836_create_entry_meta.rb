class CreateEntryMeta < ActiveRecord::Migration
  def change
    create_table :entry_meta do |t|
      t.references :entry
      t.string :key
      t.text :value

      t.timestamps
    end
    add_index :entry_meta, :entry_id
  end
end
