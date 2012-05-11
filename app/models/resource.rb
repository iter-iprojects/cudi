class Resource < ActiveRecord::Base
  belongs_to :proyecto
  has_one :user , :primary_key=>:resource , :foreign_key=>:id
end
