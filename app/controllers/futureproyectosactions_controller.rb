# encoding: UTF-8
class FutureproyectosactionsController < ApplicationController
  respond_to :html,:json, :xml
  protect_from_forgery :except => [:post_data, :editresources, :getresources, :create_histo, :post_data_actions, :list_proyect_iphone, :new_proyect_iphone, :mobile_new_proyecto]
    
  @proyectouno = Proyecto.find(:first, :include => :futureproyectosaction)

  def post_data_futureproyectosactions

    message=""
    proyects_params = {   :title => params[:title],:resources => params[:resources],:mainresource => params[:mainresource],:comments => params[:comments] }


    case params[:oper]
      when 'add'      
        if params["id"] == "_empty"
          if params[:title].present?
	    tt=params[:title]
            tt= tt.slice(0..20) if tt.length  > 16				
 
            sql = ActiveRecord::Base.connection();
            sql.execute "SET autocommit=0";
            sql.begin_db_transaction
            id, value =
            sql.insert "INSERT INTO futureproyectosactions  (title,  mainresource, priority, proyecto_id,  created_at , updated_at ) VALUES('" + tt.to_s  + "','"  + 
                        params[:mainresource].to_s + "','"  +   params[:priority].to_s  + "','" + params[:proyecto_id].to_s  + "','"   + DateTime.now.to_s + "','" + 
                        DateTime.now.to_s + "')" 
            sql.commit_db_transaction
            Resource.find_or_create_by_proyecto_id(:proyecto_id => params["proyecto_id"], :controller => 'futureproyectoactions', :resource => params[:mainresource])            
            message << ('add ok') 
          else
            message << ('Faltan datos') 
          end
        end

      when 'edit'
        proyects = Futureproyectosaction.find(params[:id]) 
        message << ('update ok') if proyects.update_attributes( :title=>params[:title],:mainresource=>params[:mainresource], :priority=>params[:priority], :proyecto_id=>params[:proyecto_id])
      when 'del'
        Futureproyectosaction.destroy_all(:id => params[:id])
        Resource.destroy_all(:proyecto_id => params[:id], :controller => 'futureproyectosaction')
        message <<  ('del ok')
      when 'sort'
        proyects = Proyecto.all
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
  
  
  def index   
    @futureproyectoactions=Futureproyectosaction.all
  
    u = Hash.new
    users=  User.find(:all) 
    users.each do |lau|
      if lau.displayname
        u[lau.id] =  lau.displayname
      else
        u[lau.id] = lau.email
      end
    end

    pu = Hash.new
    proyectos=  Futureproyectosaction.find(:all)
    proyectos.each do |pau|
      pu[pau.id] = pau.title
    end
    @proyectoselect = pu.to_a

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
      s[r.name] = r.name
    end
    @status = s.to_a

    pr = Hash.new
    priority = Priority.find(:all)
    priority.each do |r|
      pr[r.id] = r.id
    end
    @priorityselect = pr.to_a
   
    index_columns ||= [:id,:title,:mainresource,:comments, :priority, :proyecto_id ,:updated_at ]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
     
    if !params[:status_id].blank?
      session[:stfpa] = params[:status_id]
    end

    if session[:stfpa].nil?
      session[:stfpa]= "activo"
    end
   
    st = session[:stfpa] 
        
    if !params[:resource_id].blank?
      session[:rsfpa] = params[:resource_id]
    end

    if session[:rsfpa].nil?
      session[:rsfpa]= current_user.id
    end
   
    rs = session[:rsfpa] 
    
    if params[:resource_id]=='all'
    end  
    
    if !params[:mrfpa].blank?
      session[:mrfpa] = params[:mrfpa]
    end

    if session[:mrfpa].nil?
      session[:mrfpa]= "no" #por ahora 
    end
   
    mainyn = session[:mrfpa]    
    
    w=''
    w +=  " AND  futureproyectosactions.mainresource = "+session[:rsfpa].to_s  if session[:mrfpa]=='yes' && session[:pcfpa]=='no'
    w +=  " AND  resources.resource = "+session[:rsfpa].to_s if session[:mrfpa]=='no' && session[:pcfpa]=='yes'



    conditions[:select] = "distinct(futureproyectosactions.id) ,title ,comments, mainresource ,priority, futureproyectosactions.proyecto_id," +  
      "DATE_FORMAT(futureproyectosactions.created_at, '%d/%m/%Y %h:%i')  AS created_at , DATE_FORMAT(futureproyectosactions.updated_at, '%d/%m/%Y %h:%i')  AS updated_at  "
    
    if session[:pcfpa]=='no' && session[:mrfpa]=='no'
         conditions[:joins] = " WHERE 1 = 1  "
    end

    if session[:pcfpa]=='yes' && session[:mrfpa]=='no'
      conditions[:joins] = ",proyectostatuses, resources  WHERE futureproyectosactions.proyecto_id = resources.proyecto_id AND resources.controller = 'futureproyectoactions'" +  
        "AND resources.resource='"+session[:rsfpa].to_s+"' "
    end 
    
    if session[:pcfpa]=='yes' && session[:mrfpa]=='yes'
      conditions[:joins] = ",proyectostatuses, resources  WHERE futureproyectosactions.id = resources.proyecto_id OR resources.controller = 'futureproyectoaction' "
      conditions[:joins] += " OR  (futureproyectosactions.mainresource = '" + session[:rsfpa].to_s+"')" 
    end 
    
    
    if session[:pcfpa]=='no' && session[:mrfpa]=='yes'
      conditions[:joins] = ",proyectostatuses, resources  WHERE  "
      conditions[:joins] += "   (futureproyectosactions.mainresource = '" + session[:rsfpa].to_s+"')" 
    end 
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
    
    fproyectos=Futureproyectosaction.paginate(conditions)
    total_entries=fproyectos.count
    @maxsizetotalentriesfutureproyectosaction=total_entries.to_i * 250 

    rows_per_page=2000 

    respond_with(fproyectos) do |format|
      tt = ''
      fproyectos.each{|v| 
        usa=User.find(v.mainresource)
        if !usa.displayname.empty?
          v.mainresource = usa.displayname.to_s
        else
           v.mainresource = usa.email.to_s
        end
	if !v.comments.nil? 
          v.comments=sanitizehtml(v.comments)
          v.comments='<div id="accioncomentario">' + v.comments + '</div>'  
 	else
	  v.comments='<div id="accioncomentario"></div>'	
	end
        com=v.comments
        t=com.scan("'").size
        i=0
        while i < t
          n=com.index("'")
          com[n]='"'.to_s  if n
          i += 1
        end
        v.comments=com

      if !v.proyecto_id.nil?
          v.proyecto_id = Proyecto.find(v.proyecto_id).title if Proyecto.exists?(v.proyecto_id)
      else
          v.proyecto_id = 'Sin proyecto conocido'
      end  
      }
      format.json { render :json => fproyectos.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}        
    end

  end


  def getresources
       
    total_entries = 0 
    if params[:id].present? 
      index_columns ||= [:id,:resource]
      current_page = params[:page] ? params[:page].to_i : 1
      rows_per_page = params[:rows] ? params[:rows].to_i : 10
    
      proyectosa = Resource.find_all_by_proyecto_id_and_controller(params[:id], 'futureproyectosaction')
      ac=0
    
      if proyectosa.count > 0
        proyectosa.each{|c|
          if  User.find_all_by_id(c.resource).count > 0
            ac += 1 
            uf=User.find(c.resource)
            if !uf.displayname.empty?
              c.resource = uf.displayname.to_s
            else
              c.resource = uf.username.to_s   
            end
          end
        }
        total_entries = ac
        else
          proyectosa = []
          total_entries = 0
        end 
    else
    end
    
    respond_to do |format|
      format.html 
      format.json { render :template => "futureproyectosaction/index",  :json => proyectosa.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}
    end
       
  end
    
  def editresources 
    message=""
    case params[:oper]
      when 'del'
        r= Resource.destroy_all(:id => params[:id], :proyecto_id => params[:parent_id], :controller=>'futureproyectosaction')
        message <<  ('del ok')
      when 'add'
        if params["id"] == "_empty"
          if r=  Resource.find_or_create_by_proyecto_id_and_controller_and_resource(:proyecto_id => params[:parent_id].to_s, :controller => 'futureproyectosaction', 
            :resource => params[:resources].to_s)
            message << ('add ok') 
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


  def udateFromTinymce
    params[:comments]= sanitizehtml(params[:comments])  
    params[:comments]=params[:comments].html_safe
    com = params[:comments]    
    i=0
    t=com.scan("'").size
    while i < t
      n=com.index("'")
      com[n]='"'.to_s  if n
      i += 1
    end
    a=Futureproyectosaction.find(params[:id]).update_attributes(:comments => com)
    message=''
    render :json =>[false,message] and return
  end  


  def new
    @proyecto = Proyecto.new
  end


  def create
    message=""
    proyects_params = {:title => params[:title],:resources => params[:resources],:status => params[:status],:comments => params[:comments],:averange => params[:averange]}
    proyects = Proyecto.create(proyects_params)
  end


  def create_histo
    allproyects = Proyecto.all
    h2 =   allproyects.to_json
    date = DateTime.now
    documentnow = Document.find(:all, :conditions => ["date <= ?", date])

    if documentnow.count == 0 
      doc = Document.create ({ :version => 0.0, :date => date  })
      documentnow = Document.find(:all, :conditions => ["date <= ?", date])
    end

    bob = Historic.create ({:snapshoot => allproyects.to_json.html_safe,:document_version => documentnow.to_json})
  end


  def setg
    session[:mrfpa] = params[:main] if params[:en]=='main' 
    respond_to do |format|
      session[:pcfpa] = params[:pcolab] if params[:en]=='pcolab'   
      format.js {   render :json =>[false] and return }    
    end
  end 


  def list_proyect_iphone
    respond_to do |format|    
      format.jsonr do
        render :status => 400, :json => { 
               :status => :error, 
               :message => "Error!",
               :html => "... insert html ..."
        }.to_json
      end          
    end
  end   


  #need help 
  def new_proyect_iphone
    @comment = ''      
    respond_to do |format|  
      format.jsonr do
        render :json => { 
               :status => :ok, 
               :message => "Success!",
               :html => "<p></p>"
        }.to_json
      end 
    end       
  end

  #need help   
  def mobile_new_proyecto
    @profiles =  'lo pongoenprofilesy aver'
    respond_to do |format| 
      message=''
      message= 'falta un título' if params[:proyecto][:title].empty?
            
      sql = ActiveRecord::Base.connection();
      sql.execute "SET autocommit=0";
      sql.begin_db_transaction
      id, value =
      sql.insert "INSERT INTO futureproyectosactions  (title, mainresource, comments, averange, priority,  created_at ,updated_at ) VALUES('" +params[:proyecto][:title]  + 
                  "','"+ params[:proyecto][:mainresource] +"','"  + params[:proyecto][:comments] +"','"+ params[:proyecto][:averange] + 
                  "','" + params[:proyecto][:priority]  + "','"   + DateTime.now.to_s + "','" + DateTime.now.to_s + "')" 
      sql.commit_db_transaction

      Resource.find_or_create_by_proyecto_id(:proyecto_id => id, :controller => 'proyecto', :resource => params[:mainresource])

      respond_to do |format|
        render :json => message, :html => '<p>Error</p>' and return if !message.empty?
        render :json => :ok, :html => '<p>ok</p>' and return if  message.empty?
      
        format.jsonr do
          render_json_response :ok, :html => "<b>debug</b>", :message => "Ajax response succeeded!"
        end
      end 
    end
  end




  def render_json_response(type, hash)

    unless [ :ok, :redirect, :error ].include?(type)
      raise "Invalid json response type: #{type}"
    end

    default_json_structure = { 
      :status => type, 
      :html => nil, 
      :message => nil, 
      :to => nil }.merge(hash)

    render_options = {:json => default_json_structure}  
    render_options[:status] = 400 if type == :error
    render(render_options)
  end
  
  def sanitizehtml(h)
    return h

    html = h
    config = {
      :elements   => ['table','td','tr','img','p','div'],
      :attributes => {'table' => ['class','style'], 'td' => [], 'tr' => [], 'img' => ['src','alt','style','width','height']},
      :protocols  => {'class' => 'tinypersonalclasstable'}
    }

    if !html.nil?
      return Sanitize.clean(html, config)
    else
      return ''
    end
  end    
end
