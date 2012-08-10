class CommentMeta < ActiveRecord::Base
  belongs_to :comment
  
  validates :key, :presence => true
  validates :value, :presence => true
end
