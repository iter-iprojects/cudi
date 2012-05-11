module ProyectosHelper

  @listed_proyectos = Proyecto.all
  
  @filesuploads = Filesupload.all
  
  def list_pro
    Proyecto.all
  end
  
  def list_pro_json(id)
    Proyecto.where(:id => id).to_json
  end
  
  def proyectos_by_status(status)    
    @listed_proyectos.where(:status => status)    
  end
  
  def list_status
    Proyectostatus.all 
  end 
    
  def proyectos_all
    Proyecto.all
  end
  
  def users_all
    User.all
  end
  
  def status_all
    Proyectostatus.all
  end
  
  def user_all_h
    s = Hash.new
    st = User.find(:all)
    st.each do |r|
      s[r.id] = r.username
    end
    @user_all_h = s.to_a
  end

  def pictures_all
    Picture.all
  end   

end
