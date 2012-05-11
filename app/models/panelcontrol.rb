# encoding: UTF-8
class Panelcontrol < ActiveRecord::Base
  belongs_to :user
  belongs_to :role 
  validate   :changelog,  :presence => true 
end
