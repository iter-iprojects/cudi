# encoding: UTF-8
class ProyectosController < ApplicationController



  respond_to :html,:json, :xml  
  def post_data
    message=""
    
    com=params[:comments]
    com.gsub("'","\"") if !com.nil?

    proyects_params = {   :title => params[:title],:resources => params[:resources],:mainresource => params[:mainresource],:status => params[:status],:comments => com,
                          :averange => params[:averange] 
                      }

    case params[:oper]

      when 'add'
            
        if params["id"] == "_empty"

        if params[:title].present?

	  sql = ActiveRecord::Base.connection();
          sql.execute "SET autocommit=0";
          sql.begin_db_transaction
          id, value =
          com=params[:comments]
          com.gsub("'","\"") if !com.nil?

          sql.insert "INSERT INTO proyectos  (title, status, mainresource, comments, averange, priority,  created_at ,updated_at ) VALUES('" + params[:title].to_s  + "','" +
                        params[:status].to_s + "','" + params[:mainresource].to_s +  "','"  + com.to_s + "','" + params[:averange].to_s + "','" + params[:priority].to_s  + "','" + 
                        DateTime.now.to_s + "','" + DateTime.now.to_s + "')"

          sql.commit_db_transaction
          Resource.find_or_create_by_proyecto_id(:proyecto_id => id, :controller => 'proyecto', :resource => params[:mainresource])
	  create_pdf	                  
	  message << ('add ok') 
	else
	  message << ('Faltan datos') 
        end
      end

    when 'edit'
      proyects = Proyecto.find(params[:id]) 
      ps= Hash.new 
      ps= Proyectostatus.select(:name).where(:id => proyects_params[:status]) 
      ps.select {|v|    
        Resource.destroy_all(:proyecto_id => proyects_params[:id])  if v["name"] == 'borrado_definitivo'
        Proyecto.destroy_all(:id => proyects_params[:id]) if v["name"] == 'borrado_definitivo'
      }

      message << ('update ok') if proyects.update_attributes(:title=>proyects_params[:title], :mainresource=>proyects_params[:mainresource], :status=>proyects_params[:status], 
                                                             :averange=>proyects_params[:averange])
    when 'del'
      Proyecto.destroy_all(:id => params[:id])  
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

    @filesuploads = Filesupload.all
    @proyecto=Proyecto.all
  
    u = Hash.new
    users=  User.find(:all)	
    users.each do |lau|
      if lau.displayname
        u[lau.id] = lau.displayname.to_s+' | '.to_s + lau.username.to_s
      else
        u[lau.id] = lau.email.to_s+' | '.to_s + lau.username.to_s
      end
    
    end

    pu = Hash.new
    proyectos=  Proyecto.find(:all)
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
      s[r.id] = r.name.to_s 
    end
    @status = s.to_a

    pr = Hash.new
    priority = Priority.find(:all)
    priority.each do |r|
      pr[r.id] = r.name
    end
    @priorityselect = pr.to_a

    index_columns ||= [:id,:title,:mainresource,:status,:comments,:averange, :priority]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
     
    if !params[:status_id].blank?
      session[:st] = params[:status_id]
    end
    if session[:st].nil?
      session[:st]= "1"
    end
   
    st = session[:st] 
    if !params[:resource_id].blank?
      session[:rs] = params[:resource_id]
    end
    
    if session[:rs].nil?
      session[:rs]= current_user.id
    end
   
    rs = session[:rs] 
    if params[:resource_id]=='all'
    end  
    
       if !params[:mr].blank?
      session[:mainyn] = params[:mr]
    end

     if !session.include? 'mr'
	session[:mr]='no'
    end				

     if !session.include? 'pc'
        session[:pc]='no'
    end


    if session[:mainyn].nil?
      session[:mainyn]= "no" 
    end
   
    if session[:pc]==false
       session[:pc]='no' 
    end

    mainyn = session[:mr]    
    

    conditions[:select] = "distinct(proyectos.id) ,title ,resources ,status ,comments ,actions, mainresource ,priority, averange"
    
    conditions[:joins]=''


    if session[:pc]=='no'   &&  session[:mr]=='no'
      conditions[:joins] = ",resources WHERE 1 = 1  "
    end 
    if session[:pc]=='yes' && session[:mr]=='yes'
      conditions[:joins] += ",resources  WHERE  (resources.resource = '"+session[:rs].to_s+"')"
      conditions[:joins] += "    AND  (proyectos.mainresource='"+session[:rs]+"')  AND (resources.controller='proyecto')  "  
    end

    if session[:pc]=='yes' && session[:mr]=='no' 
      conditions[:joins] += ",resources  WHERE  (resources.resource = '"+session[:rs].to_s+"')  AND (resources.controller='proyecto')  AND (proyectos.id=resources.proyecto_id)   " 
    end

    if session[:pc]=='no' && session[:mr]=='yes'
      conditions[:joins] += " WHERE  (proyectos.mainresource='"+session[:rs]+"') "
    end

    conditions[:joins] += "    AND  (proyectos.status='"+session[:st]+"') "  if !session[:st].nil?


    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
    

    proyectos=Proyecto.paginate(conditions)
    total_entries=proyectos.count

    @maxsizetotalentriesproyectos=0
    rows_per_page=20000 

    respond_with(proyectos) do |format|
     
      proyectos.each{|v|
        v.status = Proyectostatus.find(v.status).name  if  Proyectostatus.exists?(v.status)  
        if User.exists?(v.mainresource)
          au=User.find(v.mainresource)
            
          if !au.displayname='nil'
            v.mainresource=au.displayname
          else
            v.mainresource = User.find(v.mainresource).email   
          end 
        end
        v.comments.gsub("'",'"')
      }

      format.json { render :json => proyectos.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}        
    end

  end
  





  def getresources
    total_entries = 0
    if params[:id].present?
      index_columns ||= [:id,:resource]
      current_page = params[:page] ? params[:page].to_i : 1
      rows_per_page = params[:rows] ? params[:rows].to_i : 10
      proyectosa = Resource.find_all_by_proyecto_id_and_controller(params[:id], 'proyecto')
      ac=0
      if proyectosa.count > 0
        proyectosa.each{|c|
	  ac += 1   if  User.find_all_by_id(c.resource).count > 0
          ur=User.find(c.resource)      
            if !ur.displayname.empty?	
              c.resource = User.find(c.resource).displayname  if User.find_all_by_id(c.resource).count > 0
              c.mainresource = User.find(c.resource).displayname  if User.find_all_by_id(c.resource).count > 0
            else
              c.resource = User.find(c.resource).email  if User.find_all_by_id(c.resource).count > 0
              c.mainresource = User.find(c.resource).email  if User.find_all_by_id(c.resource).count > 0
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
      format.json { render :json => proyectosa.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)} 
    end
  end

  def editresources
    message=""
    case params[:oper]
      when 'del'
        r= Resource.destroy_all(:id => params[:id], :proyecto_id => params[:parent_id])
        message <<  ('del ok')
      when 'add'
        if params["id"] == "_empty"
        if r=  Resource.find_or_create_by_proyecto_id_and_controller_and_resource(:proyecto_id => params[:parent_id].to_s, :controller => 'proyecto', :resource => params[:resources].to_s)
          message << ('add ok') 
        else
          message << ('El usuario ya esta vinculado a ese proyecto')
        end 		
    end
    unless (r && r.errors).blank?  
      r.errors.entries.each do |error|
        message << "<strong>#{Resource.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
      end
      render :json =>[false,message] and return
    else
      render :json => [true,message] and return
    end
   end	
    render :json =>[false,message] and return
  end


  def udateFromTinymce
 
    params[:comments].gsub("<table", "<div")
    params[:comments].gsub("<\/table", "</div")
    params[:comments].gsub("<tbody", "<div")
    params[:comments].gsub("</\tbody", "<\div")
    params[:comments].gsub("\<th\>", "<span>")
    params[:comments].gsub("\<\/th\>", "</span>")
    params[:comments].gsub("<th>", "<th>")
    params[:comments].gsub("</th>", "</th>")
    params[:comments].gsub("<tr>", "<div>")
    params[:comments].gsub("</tr>", "</div>")  
    params[:comments].gsub("\<td\>", "<span>")
    params[:comments].gsub("\<\/td\>", "</span>")
    params[:comments].gsub("<td>", "<th>")
    params[:comments].gsub("</td>", "</th>")  
    params[:comments].gsub("'","\"")
    params[:comments]=params[:comments].html_safe
    params[:comments].gsub("'",'"')

    com = params[:comments]
    com.to_s.gsub(/\\/, '\&\&').gsub(/'/, "nnnn")

    t=com.scan("'").size

    i=0
    while i < t  
      n=com.index("'")    
      com[n]='"'.to_s  if n
      i += 1  
    end  

    a=Proyecto.find(params[:id]).update_attributes(:comments => com)
    message=''
    render :json =>[false,message] and return

  end  

  def new
    @proyecto = Proyecto.new
  end


  def create
    message=""
    proyects_params = {:title => params[:title],:resources => params[:resources],:status => params[:status],:comments => params[:comments],:averange => params[:averange], :controller => 'proyecto'}
    proyects = Proyecto.create(proyects_params)
  end

  def create_pdf

    proyectosi = Proyecto.all
    File.delete('public/pdf/allproyects.pdf') if File.file?( 'public/pdf/allproyects.pdf' )
    s=''
    proyectosi.each { |v|
      du = 'aqui iran los mails de las personas y demas datos esto queda pendiente'
      s += '<tr><td>' + v.id.to_s + '</td><td>'+ v.title.to_s + '</td><td>' + v.priority.to_s + '</td><td>responsable</td><td>' + du.to_s + '</td><td>' + v.status.to_s + '</td><td>' + 
            v.comments.to_s + '</td><td>' + v.actions.to_s + '</td><td></tr>'
    }

    h='
      <table class="proyectosTable">
        <tr>
           <th id="numero" title="Numero">N</th>
           <th id="proyecto" title="Proyecto">Proyecto</th>
           <th id="prioridad" title="Prioridad">Prioridad</th>
           <th id="responsable" title="Responsable">Responsable</th>
           <th id="recursos" title="Recursos humanos">Recursos</th>
           <th id="estado" title="Estado" >Estado</th>
           <th id="comentarios" title="Comentarios">Comentarios</th>
           <th id="acciones" title="Acciones">Acciones</th>
        </tr>'
    f='</table>'
    kit = PDFKit.new(h + s + f)
    kit.stylesheets << 'public/stylesheets/proyecto.css'

    path="public/pdf/"
    Dir.mkdir(path,0) if !File.directory?(path)
    path="public/pdf/create_pdf"
    Dir.mkdir(path,0) if !File.directory?(path)

    kit.to_file('public/pdf/allproyects.pdf')
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
    session[:mr] = params[:main] if params[:en]=='main'
    respond_to do |format|
      session[:pc] = params[:pcolab] if params[:en]=='pcolab'   
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

  def new_proyect_iphone
    @comment = ''      
    respond_to do |format|  
      format.jsonr do
        render :json => { 
                          :status => :ok, 
                          :message => "Success!",
                          :html => ""
        }.to_json
      end 
    end       
  end

  #not working yet    
  def mobile_new_proyecto

    respond_to do |format|     
      message=''
      message= 'falta un título' if params[:proyecto][:title].empty?    
      var com= params[:proyecto][:comments].gsub('<br />', /\n/).to_html
        
      sql = ActiveRecord::Base.connection();
      sql.execute "SET autocommit=0";
      sql.begin_db_transaction
      id, value =
      sql.insert "INSERT INTO proyectos  (title, status, mainresource, comments, averange, priority,  created_at ,updated_at ) VALUES('" +params[:proyecto][:title]  + "','"
                 + params[:proyecto][:status] +"','"+ params[:proyecto][:mainresource] +"','"  + com  +"','"+ params[:proyecto][:averange] + "','" + params[:proyecto][:priority]  + "','"   
                 + DateTime.now.to_s + "','" + DateTime.now.to_s + "')" 
      sql.commit_db_transaction
      Resource.find_or_create_by_proyecto_id(:proyecto_id => id, :controller => 'proyecto', :resource => params[:mainresource])

      respond_to do |format|
        render :json => message, :html => '<p>wayyyyyyyyyy</p>' and return if !message.empty?
        render :json => :ok, :html => '<p>wayyyyyyyyyy</p>' and return if  message.empty?
        format.jsonr do 
          render_json_response :ok, :html => "<b>Hello, world!</b>", :message => "Ajax response succeeded!"
        end      
      end 
    end

  end


end
