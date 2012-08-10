class TaxonomyAssignment < ActiveRecord::Base
  belongs_to :entry
  belongs_to :taxonomy
  
end
