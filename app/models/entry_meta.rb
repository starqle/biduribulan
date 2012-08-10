class EntryMeta < ActiveRecord::Base
  belongs_to :entry
  
  validates :key, :presence => true
  #validates :value, :presence => true
  
  
  # Getter
  def date_value
    Time.parse(value) if value.present?
  end
  # Setter
  def date_value=(date_val)
    self.value = Time.parse('2010-11-11').to_s 
  end
  
end
