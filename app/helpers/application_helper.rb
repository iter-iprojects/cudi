module ApplicationHelper
  
  def user_can_list(u)
    Role.all 
  end
  
  def show_title?
    true
  end
  
  # Request from an iPhone or iPod touch? (Mobile Safari user agent)
  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end
  
  def get_user_agent
    if request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|iPad)/]
      request.format = :iphone
      user_agent=request.format   
    end
  end
  
  def getproyectos
    Proyecto.find(:all , :include=> :futureproyectosaction, :conditions=>{:status=>'1'})
  end
  
  def usersonlineRENONBRO
    users = User.find(:all, :conditions => ["current_sign_in_ip <> '' "]) 
  end
  
end
