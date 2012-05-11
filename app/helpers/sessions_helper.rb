module SessionsHelper
  def getrole   
    @usernow.each do |d|
      return  d.email
    end
  end 
end
