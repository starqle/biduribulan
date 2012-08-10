class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :key
      t.string :option_type
      t.text :value
      t.boolean :autoload

      t.timestamps
    end
  end
end
