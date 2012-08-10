class Comment < ActiveRecord::Base
  acts_as_nested_set
  attr_protected :lft, :rgt
  
  validates :author_name, :presence => true,
                          :if => Proc.new { |a| a.user.blank? }
  
  validates :author_email, :presence => true,
                          :if => Proc.new { |a| a.user.blank? }
  
  belongs_to :entry
  belongs_to :user
  
  has_many :comment_metas
  accepts_nested_attributes_for :comment_metas
end
