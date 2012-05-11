class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many  :roles_users, :primary_key=>:user_id  , :foreign_key => 'user_id'
end
