class Futureproyecto < ActiveRecord::Base
  has_many    :user
  has_many    :futureproyectoaction
  serialize   :resources
end
