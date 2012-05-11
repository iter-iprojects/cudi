class FutureproyectosController < ApplicationController
  respond_to :html,:json
  





  def index

    u = Hash.new
    users=  User.find(:all)	
    users.each do |lau|
      if lau.displayname.present?    
        u[lau.id] = lau.displayname
      else
        u[lau.id] = lau.email
      end
    end

    pu = Hash.new
    futureproyectos=  Futureproyecto.find(:all)
    futureproyectos.each do |pau|
      comt=pau.title
      t=comt.scan("'").size
      i=0
      while i < t
        n=comt.index("'")
        comt[n]='"'.to_s  if n
        i += 1
      end

      pau.comments=comt  
      pu[pau.id] = pau.title
      com=pau.comments
      t=com.scan("'").size
      i=0
      while i < t
        n=com.index("'")
        com[n]='"'.to_s  if n
        i += 1
      end
      pau.comments=com
    end

    @futureproyectoselect = pu.to_a

    @users = u.to_a
    grades = Hash.new
    roles = Role.find(:all)

    roles.each do |r|
      grades[r.id] = r.name
    end

    @roles = grades.to_a

    s = Hash.new
    status = Proyectostatus.find(:all)
    status.each do |r|
      s[r.id] = r.name
    end

    @status = s.to_a
   
    index_columns ||= [:id,:title,:comments]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)


    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
    
    futureproyectos=Futureproyecto.paginate(conditions)
    total_entries=futureproyectos.total_entries


    respond_with(futureproyectos) do |format|
      @futureproyectos = futureproyectos
      format.json { render :json => @futureproyectos.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
    end
  end






  def post_data_futureproyectos
    message=""
    futureproyectos_params = { :id => params[:id],  :title => params[:title],:comments => params[:comments] }
    case params[:oper]
    when 'add'
      if params["id"] == "_empty"
        sql = ActiveRecord::Base.connection();
        sql.execute "SET autocommit=0";
        sql.begin_db_transaction
        id, value =

        comt=params[:title]
        t=comt.scan("'").size
        i=0
        while i < t
          n=comt.index("'")
          comt[n]='"'.to_s  if n
          i += 1
        end

      
        com=params[:comments]

        t=com.scan("'").size
        i=0
        while i < t
          n=com.index("'")
          com[n]='"'.to_s  if n
          i += 1 
        end

        sql.insert "INSERT INTO futureproyectos  (title, comments, created_at ,updated_at ) VALUES('" + 
                    comt.to_s  + "','" + com.to_s + "','"  + DateTime.now.to_s + "','" + DateTime.now.to_s + "')"
        sql.commit_db_transaction
      end
      
    when 'edit'
      futureproyectos = Futureproyecto.find(params[:id])
      comt=params[:title]
      t=comt.scan("'").size
      i=0

      while i < t
        n=comt.index("'")
        comt[n]='"'.to_s  if n
        i += 1 
      end

      comm=params[:comments]
      t=comm.scan("'").size
      i=0

      while i < t
        n=comm.index("'")
        comm[n]='"'.to_s  if n
        i += 1
      end

      message << ('update ok') if futureproyectos.update_attributes("title"=>comt, "comments"=>comm)

    when 'del'
      Futureproyecto.destroy_all(:id => params[:id].split(","))
      message <<  ('del ok')
    when 'sort'
      proyects = Futureproyecto.all
      proyects.each do |proyects|
      proyects.position = params['ids'].index(proyects.id.to_s) + 1 if params['ids'].index(proyects.id.to_s) 
      proyects.save
    end
      message << "sort ak"
    else
      message <<  ('unknown action')
    end
    
    unless (proyects && proyects.errors).blank?  
      proyects.errors.entries.each do |error|
      message << "<strong>#{Proyecto.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
      end
      render :json =>[false,message]
    else
      render :json => [true,message] 
    end

  end


  def getresources
    if params[:id].present?

      index_columns ||= [:id,:resource]
      current_page = params[:page] ? params[:page].to_i : 1
      rows_per_page = params[:rows] ? params[:rows].to_i : 10
    
      proyectosa = Resource.where(["resources.proyecto_id = ? AND resources.controller = ?", params[:id], 'futureproyecto'] )
   
      conditions={:page => current_page, :per_page => rows_per_page}
      conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
      conditions[:joins] = " LEFT JOIN proyectostatuses  ON proyectos.id = proyectostatuses.id"
      conditions[:select] = "proyectos.id ,title ,resources ,status ,comments ,actions, mainresource ,priority, averange"
    
      ac=0
      proyectosa.each{|c|
        if  User.exists?(c.resource)
          ac += 1
          uf=User.find(c.resource)
          if uf.displayname.present?
            c.resource =uf.displayname
          else
            c.resource=uf.email
          end
        end
      }

      total_entries = ac
    else
      proyectosa = []
      total_entries = 0
    end
    respond_to do |format|
      format.html 
      format.json { render :json => proyectosa.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)} 
    end   
  end

  def editresources
      
    message=""

    case params[:oper]
      when 'del'
        r= Resource.destroy_all(:id => params[:id], :proyecto_id => params[:parent_id], :controller=>'futureproyecto')
        message <<  ('del ok')
      when 'add'
        if params["id"] == "_empty"
          if r=  Resource.find_or_create_by_proyecto_id_and_controller_and_resource(:proyecto_id => params[:parent_id].to_s, :controller => 'futureproyecto', :resource => params[:resources].to_s)
          message << ('add ok') #if proyectre.errors.empty?
          else
            message << ('El usuario ya esta vinculado a ese proyecto')
          end
        end
      unless (r && r.errors).blank?
        r.errors.entries.each do |error|
          message << "<strong>#{Resource.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
        end
        render :template => "index",  :json =>[false,message] and return
      else
        render :template => "index", :json => [true,message] and return
      end
    end
    render   :template => "index", :json =>[false,message] and return

  end


end
