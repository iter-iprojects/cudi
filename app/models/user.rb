class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :roles_users

  devise  :database_authenticatable, :token_authenticatable,:rememberable,  :validatable 

  attr_accessible :username, :password, :password_confirmation, :remember_me, :role_ids,  :displayname, :telephonenumber, :email, :cn

  validates_presence_of   :username
  validates_uniqueness_of :username


  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end
   
  def set_default_create_role   
    self.role_ids= ["2"]
  end

end

