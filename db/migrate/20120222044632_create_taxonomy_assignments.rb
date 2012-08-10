class CreateTaxonomyAssignments < ActiveRecord::Migration
  def change
    create_table :taxonomy_assignments do |t|
      t.references :entry
      t.references :taxonomy

      t.timestamps
    end
    add_index :taxonomy_assignments, :entry_id
    add_index :taxonomy_assignments, :taxonomy_id
  end
end
