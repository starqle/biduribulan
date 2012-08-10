class User < ActiveRecord::Base
  has_many  :role_assignments, :dependent => :destroy
  has_many  :roles, :through => :role_assignments
  has_many  :entries
  has_many  :comments
  has_many  :authentications
  
  has_many :final_project_assignments, :dependent => :destroy
  has_many :final_projects, :through => :final_project_assignments
  
  has_many :user_metas
  accepts_nested_attributes_for :user_metas
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids, :final_project_ids
  
  def apply_omniauth(omniauth)
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def role_symbols
     (roles || []).map {|r| r.name.underscore.to_sym}
  end
  
  def is?(role)
    role_symbols.include?(role)
  end
end
