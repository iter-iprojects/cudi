
class ActionsController  < ApplicationController
  respond_to :html,:json
  
  protect_from_forgery :except => [:post_data_actions]
  
  

  def post_data_actions
    message=""
    actions_params = {   :title => params[:title],:resources => params[:resources],:status => params[:status],:comments => params[:comments],:averange => params[:averange] }
    case params[:oper]
    when 'add'
      if params["id"] == "_empty"

        sql = ActiveRecord::Base.connection();
        sql.execute "SET autocommit=0";
        sql.begin_db_transaction
        id, value =
      

        sql.insert "INSERT INTO actions  (title, proyecto, comments, created_at ,updated_at ) VALUES('" + params[:title].to_s  +  "','" + params[:proyecto].to_s + 
                   "','" + params[:comments].to_s + "','"  + DateTime.now.to_s + "','" + DateTime.now.to_s + "')" 

        sql.commit_db_transaction
	create_pdf
      end
      
    when 'edit'
      proyects = Action.find(params[:id])
      message << ('update ok') if proyects.update_attributes(actions_params)

    when 'del'
      Action.destroy_all(:id => "2")
      message <<  ('del ok')

    when 'sort'
      proyects = Action.all
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
        message << "<strong>#{Action.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
      end
      render :json =>[false,message]
    else
      render :json => [true,message] 
    end
  end
  
  
  def index
	 
    u = Hash.new
    users=  User.find(:all)	
    users.each do |lau|
      u[lau.id] = lau.email
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
      s[r.id] = r.name
    end
    @status = s.to_a




    index_columns ||= [:id,:title,:name,:comments,:proyecto]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    conditions[:select] = "*"

	
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
    

    actions=Action.paginate(conditions)
    total_entries=actions.total_entries


    respond_with(actions) do |format|
=begin
      actions.each{|v|	       
      }
=end
      format.json { render :json => actions.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}        
    end
  end

  def getresources

    if params[:id].present?

      index_columns ||= [:id,:resources]
      current_page = params[:page] ? params[:page].to_i : 1
      rows_per_page = params[:rows] ? params[:rows].to_i : 10
   
      proyectosa = Proyectoresource.where(:proyectoid => params[:id] )
       
      ac=0
      proyectosa.each{|c|
        ac += 1   if  User.exists?(c.resources)
        c.resources = User.find(c.resources).email  if  User.exists?(c.resources)
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
        Action.destroy_all(:id => params[:id])
      	message <<  ('del ok')
      when 'add'
        if params["id"] == "_empty"
	  proyectre=Action.create(:title => params[:title].to_s, :comments => params[:comments].to_s, :proyecto => params[:proyecto].to_s ) 
	  message << ('add ok') if proyectre.errors.empty?			
	end

        respond_to do |format|

          if proyectre.errors.empty?
            allproyects = Action.all  
            h2 = allproyects.to_json 
            date = DateTime.now
            documentnow = Document.find(:all, :conditions => ["date <= ?", date])
            bob = Historic.create ( {:snapshoot => allproyects.to_json.html_safe, :document_version => documentnow.to_json} )	 
          end
	end
					
    end	

  end


  def new
  end


  def create

    message=""
    actions_params = {:title => params[:title],:resources => params[:resources],:status => params[:status],:comments => params[:comments],:averange => params[:averange]}
    actions = Action.create(actions_params)

   end


  def create_pdf

    proyectosi = Proyecto.all

    File.delete('public/pdf/allproyects.pdf') if File.file?( 'public/pdf/allproyects.pdf' )
    s=''

    proyectosi.each { |v|
      du = ''
      s += '<tr><td>' + v.id.to_s + '</td><td>'+ v.title.to_s + '</td><td>' + v.priority.to_s + '</td><td>responsable</td><td>' + du.to_s + '</td><td>' + v.status.to_s + 
           '</td><td>' + v.comments.to_s + '</td><td>' + v.actions.to_s + '</td><td></tr>'
    }

    h= '<table class="proyectosTable">
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

    kit.to_file('public/pdf/allproyects.pdf')

    @user = User.all
    @user.each do |v|
      UserMailer.send_pdf(v.email.to_s, h + s + f).deliver
    end
  end

end
