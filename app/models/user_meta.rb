class UserMeta < ActiveRecord::Base
  belongs_to :user
  
  validates :key, :presence => true
  validates :value, :presence => true
end
