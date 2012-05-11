# encoding: UTF-8
class Cudidoc < ActiveRecord::Base
  
  before_save :make_parse
  before_create :make_parse
    def make_parse 
      string = self.contain.to_s
    end    
end


















