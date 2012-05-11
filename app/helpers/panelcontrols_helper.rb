module PanelcontrolsHelper
  
  def get_users_roles(iduser)
    @listed_rol = Roles_users.find(:first,  :conditions => ["user_id = ?", iduser] )
  end   
  
  
  @u= User.all
  def list_user_roles
  end
  
  def get_last_doc_version
    @last_doc_version=Document.last.version
  end
  
  def get_last_doc_created_at
    @last_doc_created_at=Document.last.created_at
  end
  
  def getproyectos
    Proyecto.find(:all , :include=> :futureproyectosaction, :conditions=>{:status=>'1'})
  end
  
  def getproyectosresources(va)
    Resource.find(:all, :include=>:user, :conditions=>{:controller=>'proyecto',:proyecto_id=>va})
  end 
  
  def getfutureproyectosaction(proyecto_id)
    Futureproyectosaction.find(:all, :include=> :resource  ,  :conditions=>["proyecto_id = ?", proyecto_id] )
  end
  
  def getrelactionfutureproyectosproyectos
    Futureproyectosaction.find(:all, :include=> :proyecto, :include=>:resource) 
  end  
  
  def getresourcesforfutureproyectoaction(va)
    Resource.find(:all, :include=>:user,:conditions=>{:controller=>'futureproyectosaction',:proyecto_id=>va})
  end 

  def getalluserroles
    a=User.find(:all)
    a.each do |t|
      b=Roles_user.find(:first, :conditions=>{:user_id=>t.id})
        if !b.nil?
          c=Role.find(:first, :conditions=>{:id=>b.role_id}) 
          if t.displayname.present?
            if !t.displayname.empty? 
              t.email= t.displayname.to_s + '|'.to_s + c.name.to_s
            else
              t.email=t.username.to_s + '|'.to_s + c.name.to_s
            end
          end
        else
	  t.email=t.username.to_s + '|'.to_s + 'Rol si asignar'.to_s	
        end
    end
    return a		
  end   
end
