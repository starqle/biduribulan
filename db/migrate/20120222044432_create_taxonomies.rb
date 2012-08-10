class CreateTaxonomies < ActiveRecord::Migration
  def change
    create_table :taxonomies do |t|
      t.string :name
      t.string :taxonomy_type
      t.string :slug
      t.text :description
      t.integer :taxonomy_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.integer :menu_order

      t.timestamps
    end
  end
end
