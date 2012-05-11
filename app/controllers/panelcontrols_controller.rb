# encoding: UTF-8
class PanelcontrolsController < ApplicationController

  def set_charset
    str_type = request.xhr? ? 'javascript' : 'html'
    headers['Content-Type'] = "text/#{str_type}; charset=utf8"
  end


  def index
    @panelcontrols = Panelcontrol.all

    respond_to do |format|
      @users = User.all
      @roles = Role.all
      format.html # index.html.erb
      format.xml  { render :xml => @panelcontrols }
    end
  end


  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @panelcontrol }
    end
  end


  def new
    @panelcontrol = Panelcontrol.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @panelcontrol }
    end
  end


  def edit
    @panelcontrol = Panelcontrol.find(params[:id])
  end


  def create
    @panelcontrol = Panelcontrol.new(params[:panelcontrol])

    respond_to do |format|
      if @panelcontrol.save
        format.html { redirect_to(@panelcontrol, :notice => 'Panelcontrol was successfully created.') }
        format.xml  { render :xml => @panelcontrol, :status => :created, :location => @panelcontrol }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @panelcontrol.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=0";
    sql.begin_db_transaction 
    id, value =	
    sme=""


    if params.include?  ('user') 
      params[:user]['id'].each do |a|	   
        sme += '"'+a.to_s+'"'+','.to_s
        Roles_user.find_or_create_by_user_id(:user_id => a.to_s, :role_id => params[:rol]['id'].to_s)
      end  
	 
      sme = sme.sub!(/.{1}$/,''); 

      sql.update "UPDATE roles_users  SET role_id=" + params[:rol]['id'].to_s  + " WHERE user_id IN ("+ sme +')';
      sql.commit_db_transaction 

      flash[:notice] = "Se ha modificado con éxito, el rol de usuarios".to_s
    else
      flash[:notice] = "Es necesario seleccionar como mínimo un usuario".to_s
    end
    redirect_to panelcontrols_path
  end


  def destroy
    @panelcontrol = Panelcontrol.find(params[:id])
    @panelcontrol.destroy

    respond_to do |format|
      format.html { redirect_to(panelcontrols_url) }
      format.xml  { head :ok }
    end
  end

  def generate_document

    allproyects = Proyecto.all
    h2 =   allproyects.to_json
    date = DateTime.now
    v=  Document.last

    if  v ==  '' || v == nil
      doc = Document.create ({ :version => 0,  :changelog => 'sin notas adicionales añadidas', :date => date  })
    else
      version = v.version.to_i + 1 
      doc = Document.create ({ :version => version, :changelog => params[:changelog][:text], :date => date  
                             })
    end

    version=  Document.last

    bob = Historic.create ({:snapshoot => allproyects.to_json.html_safe, :document_version => version.to_json
                           })
    create_graph
    create_pdf('definitivo')
  end


  def create_graph
    escaped_snapshoot =  '[{"proyecto'
    @Historics = Historic.find(:all, :order => "created_at desc", :limit => 2, :conditions=> ["snapshoot like ?", escaped_snapshoot + "%"] )
    create_up_history if @Historics.count < 1
  
    histo3 = []
    @s= []
    v2 =[]   
    @mira=''
    @porta=''
    ven=''
    @h = Hash.new()
    @ht = Hash.new()
    @h1 = Hash.new()
    @h2 = Hash.new()
    @hid = Hash.new()
     
    nh= @Historics.count()
    n=1 
    test1= []
    
    temp=[]
    n=1
    mc=[]

  
    require 'gruff'

    g = Gruff::Bar.new()
  
    g.title = "Seguimiento de Proyectos Activos" 
    g.font = File.expand_path('public/fonts/FORTE.TTF', Rails.root)
    g.no_data_message = 'No datos aportados'
    g.theme = {
                :colors => %w(#e8e8e8 #dfdfdf #d0d0d0  #c0c0c0  #869023  ),
                :marker_color => '#aaa',
                :background_colors => %w(#fff  #ececec  ),
                :marker_font_size => '11px'
    }
  

    proyectosactuales=Proyecto.find(:all,:conditions => ["status='1'"])    
    s= Hash.new
    i= []
    n=0

    proyectosactuales.each do |pa|

      s[n] = wrap_text(pa.title.to_s, col = 20) 
      i.push(pa.id.to_s) 
      n += 1 
    end

    c=0
    shisto=[]
    sdoc= Hash.new
    ave=[]
    ve=''

                 
    n=5
    n=Historic.count if Historic.count < n
    Historic.last(5).each do |histo|       
      shisto = ActiveSupport::JSON.decode(histo.snapshoot) if !histo.snapshoot.nil?
      sdoc   =   ActiveSupport::JSON.decode(histo.document_version) if ! histo.document_version.nil? 
        
      ve =   "v" + sdoc["document"]["version"].to_s
      aAVE=[]
      i.each {|pid|       
        sAVE='0'
        shisto.select {|v|         
        sAVE = v["proyecto"]["averange"].to_s  if pid.to_s == v["proyecto"]["id"].to_s                                  
        }
        aAVE.push(sAVE.to_i)
      }
      g.data(ve, aAVE) 
    end    

    g.labels =  s 
    g.maximum_value = 100 # Declare a max value for the Y axis
    g.minimum_value = 0   # Declare a min value for the Y axis
    g.font = 'tahoma'
    g.legend_font_size = 11
    g.marker_font_size = 11
    g.title_font_size = 13
    g.legend_box_size = 10
    g.sort = false
    g.write('public/images/img_graph.png')
    g.write('public/images/img_graph.svg')
 
  end


  def wrap_text(txt, col = 80)
    return txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/,
                    "\\1\\3\n") 
  end


  def create_pdf(tipo='')
    proyectosi = Proyecto.all
    filename=File.basename("/public/pdf/create_pdf/") 
    remove_files('public/pdf/create_pdf', 0)

    s=''
    sland=''
    slandc=''
    slandcACTIVO=''
    slandcFINALIZADO='' 
    du=''

    doc= Document.last
    
    create_histo if Historic.count < 2
 
    hl =Historic.last(2).reverse
    h=1
    h1 = Hash.new
    h2 = Hash.new
    hl.each { |c|
      h1= c.snapshoot if h==1
      h2= c.snapshoot if h==2
      h += 1
    }

    new_json = ActiveSupport::JSON.decode(h1)
    before_json = ActiveSupport::JSON.decode(h2)


    a= new_json.find(:id => 6)
    compare=''
    new_json.each do |x|
      before_json.each do |y|
        if y["proyecto"]["id"] == x["proyecto"]["id"]
          t= Time.parse(y["proyecto"]["updated_at"])  if y["proyecto"]["averange"].to_s == x["proyecto"]["averange"].to_s 
          compare += '<tr><td> ' + y["proyecto"]["title"].to_s + '</td><td> Sin cambios</td><td> '+ y["proyecto"]["averange"].to_s+'%</td><td> ' + 
                      t.strftime("%d-%m-%Y  T%H:%M:%SZ") + '</td></tr>'   if y["proyecto"]["averange"].to_s == x["proyecto"]["averange"].to_s
          a=y["proyecto"]["averange"].to_i - x["proyecto"]["averange"].to_i if y["proyecto"]["averange"].to_s != x["proyecto"]["averange"].to_s
	  compare += '<tr><td>' + y["proyecto"]["title"].to_s + '</td><td>' + y["proyecto"]["averange"].to_s + '%</td><td>'  + x["proyecto"]["averange"].to_s + 
                     '%</td><td> '+a.abs.to_s+'% </td></tr>' if y["proyecto"]["averange"].to_s != x["proyecto"]["averange"].to_s
        end
      end
    end

    s +=  '<div id="pdfcontain" class="portrait" style="font-family: Tahoma, Helvetica, Arial, sans-serif;">'  
    s += '<div id="pdfheader">'
  

    if (tipo=='definitivo')  
      s +=  '<h1>Coordinacion de la unidad de desarrollo</h1>
             <div class="resumen"><strong>Resumen.</strong> Con el objetivo de establecer un seguimiento de los proyectos que la unidad de desarrollo se encuentra abordando en estos momentos 
                                  y así establecer un orden de prioridades y de acciones globales a llevar a cabo, se genera este documento de coordinación de la unidad de desarrollo.</div> 
             </div>'  
    else
      s +=  '<DIV style="color:red; align:center;"><h2>Documento Provisional</h2></DIV><p class="firsttitle">Coordinacion de la unidad de desarrollo</p>
             <div class="resumen"><strong>Resumen.</strong> Con el objetivo de establecer un seguimiento de los proyectos que la unidad de desarrollo se encuentra 
                                  abordando en estos momentos y así establecer un orden de prioridades y de acciones globales a llevar a cabo, se genera este documento 
                                  de coordinación de la unidad de desarrollo.
             </div> 
             </div>'
    end    
        
  
    s += '<p class="secondtitle">Informacion del documento.</p>
          <ul class="secondcontain">
            <li><span class="bolde" style="font-weight: bold;">Proyecto: </span><span> Coordinación de la unidad de desarrollo</span></li>
            <li><span class="bolde" style="font-weight: bold;">Destino: </span><span>  Interno. Departamento de Informática. Unidad de desarrollo.</span></li>
            <li><span class="bolde" style="font-weight: bold;">Autor: </span><span> Autor.</span></li>
            <li><span class="bolde" style="font-weight: bold;">Fecha: </span><span> ' + doc.created_at.to_s + '</span></li>
            <li><span class="bolde" style="font-weight: bold;">Estado: </span><span> En Proceso </span></li>
          </ul>'

    s += '<p class="secondtitle">Información de la versión del documento.</p>
          <ul style="list-style-type: none;" class="secondcontain"><li><strong>Versión:</strong>' +doc.version+ '</li>
            <li><strong>Alcance:</strong> Este documento sustituye a la versión anterior   </li>
            <li><strong>Notas:</strong></li>
          </ul>'

    s += '<p class="secondtitle">Control de versiones del documento (5 últimos documentos)</p>'

    docu=Document.last(5)
    s += '<table class="subtabla align-center secondcontain" style="page-break-inside: avoid; margin-left:20px;">'
    s += '<tr>'    
    s +='<th id="vers" title="Version">Versión</th><th id="fech" title="Fecha">Fecha</th><th id="modific" title="Modificaciones">Modificaciones respecto a la versión anterior</th></tr>'

    sw=1
    docu.each{|d|       
      if (sw%2) == 0
        s += '<tr class="firstTR"> <td>'+d.version.to_s  + '</td> <td>' + d.created_at.strftime("%d/%m/%Y") + '</td><td class="align-left">' +d.changelog.to_s + '</td> </tr>' 
      else
        s += '<tr class="secondTR"> <td>'+d.version.to_s  + '</td> <td>' + d.created_at.strftime("%d/%m/%Y") + '</td><td class="align-left">' +d.changelog.to_s + '</td> </tr>'       
      end
    
      sw += 1
   
    }

    s += '</table>'
    s +='<p class="secondtitle">Contenido</p>    
    <ol class="OlContenido secondcontain">
      <li> Resumen de cambios. <span>1</span></li>
      <li> Notas para acciones futuras. <span>2</span></li>
      <li> Estado de los proyectos en activo, Acciones a realizar. <span>3</span></li>
      <li> Proyectos detenidos. <span>4</span></li>
      <li> Proyectos eliminados. <span>5</span></li>
      <li> Proyectos Finalizados. <span>6</span></li>
    </ol>'

    src=''
    src +='<h1>1. Resumen de cambios</h1> 
           <table class="subtabla" style="page-break-inside: avoid;">
           <tr> <th>Estado</th> <th>Prioridad 1</th> <th>Prioridad 2</th> <th>Prioridad 3</th> <th>Total</th> </tr>'

    sa =''
    p1=''
    p2=''
    p3=''
    sw=1
    Proyectostatus.find(:all).each do |ps|
      stotal= Proyecto.count(:conditions => "priority ='1' AND  status =".to_s + ps.id.to_s).to_i   + 
              Proyecto.count(:conditions => "priority ='2' AND  status =".to_s + ps.id.to_s).to_i + 
              Proyecto.count(:conditions => "priority ='3' AND  status =".to_s + ps.id.to_s).to_i  
      if (sw%2) == 0
        sa += '<tr class="firstTR"> <td>'  + ps.name.to_s  +  '</td> <td>' + Proyecto.count(:conditions => "priority ='1' AND  status =".to_s + ps.id.to_s  ).to_s + 
              '</td> <td>' + Proyecto.count(:conditions => "priority ='2' AND  status =".to_s + ps.id.to_s  ).to_s + ' </td><td>' + 
              Proyecto.count(:conditions => "priority ='3' AND  status =".to_s + ps.id.to_s  ).to_s  +  
              '</td><td>'.to_s + stotal.to_s + ' </td>'.to_s 
      else
        sa += '<tr class="secondTR"> <td>' + ps.name.to_s  +  '</td> <td>' + Proyecto.count(:conditions => "priority ='1' AND  status =".to_s + ps.id.to_s  ).to_s + 
              '</td> <td>' + Proyecto.count(:conditions => "priority ='2' AND  status =".to_s + ps.id.to_s  ).to_s + ' </td><td>' + 
              Proyecto.count(:conditions => "priority ='3' AND  status =".to_s + ps.id.to_s  ).to_s  +  '</td><td>'.to_s + stotal.to_s + ' </td>'.to_s         
      end   
      sw += 1 
    end
     
  src += sa
  src += '</table>'


  #notas para acciones futuras
  sfpa=''
  sfpa +='<div style="page-break-inside:avoid; "><h1 >2. Notas para acciones futuras</h1> <table class="subtabla"> <tr> <th>Proyecto/título</th> <th>Notas</th><th>Recursos</th></tr>'
  sw=0

  Futureproyecto.find(:all).each do |na| 
    futurenotasresource = Resource.where(["resources.proyecto_id = ? AND resources.controller = ?", na.id.to_s, 'futureproyecto'] )       
    fure=''
 
    futurenotasresource.each do |fr|             
      usfr= User.find(fr.resource.to_s)

      if !usfr.displayname='nil'
        usa= usfr.displayname
      else
        usa=usfr.username
      end

      fure += '-'.to_s + usa.to_s
    end

  if (sw%2==0)     
      sfpa += '<tr class="secondTR"><td>' + na.title.to_s + '</td><td>' +  na.comments.to_s + '</td><td>' + fure.to_s  + ' </td></tr>' 
        
    else
       sfpa += '<tr class="firstTR"><td>' + na.title.to_s + '</td><td>' +  na.comments.to_s + '</td><td>' + fure.to_s  + ' </td></tr>'
    end  
    sw += 1
  end  
  sfpa += '</table></div>'

  page = request.path_parameters

  sgraph=''
  sgraph= '<img id="pdfgraph" src="'+Rails.root.to_s+'/public/images/img_graph.png">'
 
  src += sgraph + sfpa 

  sw=1

  proyectosi.each { |v|
    aresfutureproaction=''
    arescomments=''
    
    if !getfutureproyectosactionresources(v.id.to_s).nil?
      colab='Colab:'
      usa=''
      getfutureproyectosactionresources(v.id.to_s).each {|n|
        if User.where(:id => n.resource.to_s).present?	
        usafp= User.find(n.resource.to_s)

        if !usafp.displayname='nil'
          usa= usafp.displayname
        else
          usa=usafp.username
        end

        aresfutureproaction +=  usa      
        end
      }       
    end  
    
    if  !Futureproyectosaction.find_by_proyecto_id(v.id).nil? 
      @fpaa=Futureproyectosaction.find_by_proyecto_id(v.id)
      aresfutureproaction += '<br>Main Res: '.to_s + User.find(@fpaa.mainresource).username.to_s + '<br>'.to_s + @fpaa.comments.to_s
    end
    
    if v.id !=nil?
      lr=Resource.select(:resource).where(:proyectoid => v.id.to_s)    
      lr.each{|c|
        if User.exists?(v.resource.to_s)
          du += '<p> '  + User.find(v.resource.to_s).email + '</p>'     
        end  
      } 
    end
    
    if User.exists?(v.mainresource.to_s)
      mr=User.find(v.mainresource.to_s).email
      mr += User.find(v.mainresource.to_s).username.to_s
    else
      mr='Eliminado (id):' + v.mainresource.to_s
    end  

    stv=''
    st=Proyectostatus.select(:name).where(:id => v.status.to_s)
    st.each{|c|
      stv=c.name
    }

 
  }
    

  s += '</div><!-- #pdfcontain -->'
  slandACTIVO='<span>'
  slandACTIVO +='<h1>3. Proyectos Activos</h1><TABLE class="activos" style="width:1200px;" ><TR><TH id="thtitulo">Título</TH><TH id="threcursos">Recursos</TH>' +
                '<TH id="thcomentarios">Comentarios</TH><TH id="htacciones">A. Futuras</TH><TH id="thporcentage">%</TH><TH id="thprioridad">Prioridad<TH></TR>'
  getproyectos('1').each do |z,v|
    slandACTIVO += '<TR  style="page-break-inside:avoid; " ><TD>' + z.title.to_s + '</TD>'

    slandACTIVOrecurses=''
    getproyectosresources(z.id).collect do |u|  

      if u.user
        classresponsable='recursogeneral'	
        if u.user.id.to_i==z.mainresource.to_i  
	  classresponsable='ismainresource'
        end
        slandACTIVOrecurses += '<span class="'+classresponsable.to_s+'">C: ' + u.user.username.to_s   + '-'.to_s  + '<span>'
        end 
      end

      slandACTIVO += '<td>' + slandACTIVOrecurses + '</td>'	
      slandACTIVO += '<td style="width: 200px; text-align: left; height: 150px;">' +   z.comments.to_s + '</td>'.to_s
      slandACTIVO += '<td style="text-align:left;  width:350px;">'.to_s  


      if z.futureproyectosaction.count > 0
        z.futureproyectosaction.collect do |u|   

          if getresourcesforfutureproyectoaction(u.id).count > 0
            getresourcesforfutureproyectoaction(u.id).each do |b|  
              slandACTIVO += '<span id="recursosacciones">'
              b.user.username if b.user
              slandACTIVO += '</span>'.to_s
            end

            rua=''
            ufmr=User.find(u.mainresource) 
            if !ufmr.displayname.empty?
              rua=ufmr.displayname
            else
              rua=ufmr.username
            end     
          end

          slandACTIVO += '<span id="tituloaccion">' + u.title + '</span>'.to_s

          if u.comments   
            slandACTIVO += '<span id="comentarioaccion">'.to_s  +   u.comments + '</span>'.to_s
          end
          slandACTIVO += '</td>'.to_s 
        end
      end 
  

      slandACTIVO += '<td>' + z.averange.to_s  + '%</td>'.to_s
      slandACTIVO += '<td>' + z.priority.to_s  + '</td>'.to_s

  end 

  slandACTIVO += '</tr></table></span>'	 


 
  slandFINALIZADO = ''
  slandFINALIZADO += "<div style='page-break-before:avoid;'><h1>6. Proyectos Finalizados</h1>"
  slandFINALIZADO += "<ul>"

  getproyectos('3').each do |z,v|
    slandFINALIZADO += "<li>" + z.title.to_s  + '  ' + z.updated_at.to_s + "</li>"   
  end

  slandFINALIZADO += "</ul></div>"  
 

 
  hot= 'http://'.to_s+request.host_with_port.to_s
 
  src = src.gsub('src="uploads','src="'+hot+'/uploads')
  slandACTIVO = slandACTIVO.gsub('src="uploads','src="'+hot+'/uploads')
  slandFINALIZADO = slandFINALIZADO.gsub('src="uploads','src="'+hot+'/uploads')

   
  kitsrc = PDFKit.new(src,  :orientation => 'Landscape' , :header_spacing=>26, :footer_html => Rails.root.to_s+"/public/pdf/html/footer_pdf.html",  
                            :footer_line => true,  :header_html => Rails.root.to_s+"/public/pdf/html/header_pdf.html")


  kitlandACTIVO = PDFKit.new(slandACTIVO ,:orientation => 'Landscape',  :header_spacing=>26,  
                                          :footer_html => Rails.root.to_s+"/public/pdf/html/footer_pdf.html", :header_line => true,   :footer_line => true,  
                                          :header_html => Rails.root.to_s+"/public/pdf/html/header_pdf.html")

  kitlandFINALIZADO = PDFKit.new(slandFINALIZADO, :header_spacing=>26, :orientation => 'Landscape', :footer_html => Rails.root.to_s+"/public/pdf/html/footer_pdf.html",  
                                                  :footer_line => true,  :header_html => Rails.root.to_s+"/public/pdf/html/header_pdf.html")


  kit = PDFKit.new( s ,  :orientation => 'Portrait', :header_spacing=>26, :footer_html => Rails.root.to_s+"/public/pdf/html/footer_pdf.html", 
                         :footer_line => true,   :header_html => Rails.root.to_s+"/public/pdf/html/header_pdf.html" )
   
  kitsrc.stylesheets << 'public/stylesheets/sentpdf.css'	
  kit.stylesheets << 'public/stylesheets/sentpdf.css'

  kitlandACTIVO.stylesheets << 'public/stylesheets/sentpdf.css'
  kitlandFINALIZADO.stylesheets << 'public/stylesheets/sentpdf.css'


  doc.created_at.strftime("%A%d%B")
  path=Rails.root.to_s+"/public/pdf/"
  Dir.mkdir(path,0777) if !File.directory?(path)
  path=Rails.root.to_s+"/public/pdf/create_pdf"
  Dir.mkdir(path,0777) if !File.directory?(path)

  begin
    File.chmod(0777, Rails.root.to_s+'/public/pdf/create_pdf/') if File.directory?(Rails.root.to_s+'/public/pdf/create_pdf/') 
  rescue
    puts 'permision error'
  end	

  path=Rails.root.to_s+"/historydocs"
  Dir.mkdir(path,0777) if !File.directory?(path)
  
  local_filename ="/tmp/cosasdeanelia.html"
  adoc  =  s.to_s +  kitsrc.to_s +  slandACTIVO.to_s +  slandFINALIZADO.to_s 
  File.open(local_filename, 'w') {|f| f.write(adoc) 
                                 }


  kitlandACTIVO.to_file(Rails.root.to_s+'/public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + 
                        '_ACTIVOlandscape_v' + doc.version.to_s + '.0.pdf')
  kitlandFINALIZADO.to_file(Rails.root.to_s+'/public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + 
                            '_FINALIZADOlandscape_v' + doc.version.to_s + '.0.pdf')

    
  File.chmod(0777, Rails.root.to_s+'/public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + 
             '_ACTIVOlandscape_v' + doc.version.to_s + '.0.pdf' )
  File.chmod(0777, Rails.root.to_s+'/public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + 
             '_FINALIZADOlandscape_v' + doc.version.to_s + '.0.pdf')
  
  
  kit.to_file('public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + '_pdevelopers_v' + doc.version.to_s + '.0.pdf')
  kitsrc.to_file('public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + '_SRCpdevelopers_v' + doc.version.to_s + '.0.pdf')

  
  File.chmod(0777, 'public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + '_SRCpdevelopers_v' + doc.version.to_s + '.0.pdf' )
  File.chmod(0777, 'public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + '_pdevelopers_v' + doc.version.to_s + '.0.pdf' )

  pdfposition1=''
  pdfposition2=''
  pdfposition3=''
  pdfposition4=''
  pdfposition5=''
  pdfposition6=''
  
  pdfsalida= Rails.root.to_s +  '/public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I_%M%p").to_s + 
             'ready_pdevelopers_v' + doc.version.to_s + '.0.pdf '
  pdfsalidagene= Rails.root.to_s +  '/public/pdf/create_pdf/salidagenerica.pdf'
  pdfhistoricos= Rails.root.to_s + 

  pdfposition1= ' public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + '_pdevelopers_v' + doc.version.to_s + '.0.pdf '
  pdfposition2= ' public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + '_SRCpdevelopers_v' + doc.version.to_s + '.0.pdf     ' 
  pdfposition3= ' public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + '_ACTIVOlandscape_v' + doc.version.to_s + '.0.pdf '
  pdfposition4= ' public/pdf/create_pdf/' +  doc.created_at.strftime("%A%d%B_%Y_at_%I:%M%p").to_s + '_FINALIZADOlandscape_v' + doc.version.to_s + '.0.pdf '

  
  File.chmod(0777, pdfposition1) if File.exist?(pdfposition1)
  File.chmod(0777, pdfposition2) if File.exist?(pdfposition2)
  File.chmod(0777, pdfposition3) if File.exist?(pdfposition3)
  File.chmod(0777, pdfposition4) if File.exist?(pdfposition4)
  File.chmod(0777, pdfposition5) if File.exist?(pdfposition5)
  
  system("pdftk "+  pdfposition1  +    pdfposition2     +    pdfposition3     +    pdfposition4  +  pdfposition5  +  pdfposition6   +  ' cat output '  +  pdfsalida  )
  system("pdftk "+  pdfposition1  +    pdfposition2     +    pdfposition3     +    pdfposition4  +  pdfposition5  +  pdfposition6   +  ' cat output '  +  pdfsalidagene  )


  if (tipo=='definitivo')
    hpath= path +'/'.to_s + doc.created_at.strftime("%Y%m%d_%H%M").to_s + '_historic_v' + doc.version.to_s + '.pdf'
    system("pdftk "+  pdfposition1  +    pdfposition2     +    pdfposition3     +    pdfposition4  +  pdfposition5  +  pdfposition6   +  ' cat output '  +  hpath  )
  end

  File.chmod(0777,   pdfposition1 ) if File.exist?(pdfposition1)
  File.chmod(0777,   pdfsalida ) if File.exist?(pdfsalida)

  
  File.delete(pdfposition1) if File.exist?(pdfposition1)
  File.delete(pdfposition2) if File.exist?(pdfposition2)
  File.delete(pdfposition3) if File.exist?(pdfposition3)
  File.delete(pdfposition4) if File.exist?(pdfposition4)
  File.delete(pdfposition5) if File.exist?(pdfposition5)


  respond_to do |format|
    if request.xhr?
      format.js {render :partial => "createpdf", :locals => { :notice => 'el informe ha sido actualizado' }, :content_type => 'text/javascript'}    
    else  
      format.html { redirect_to(panelcontrols_url, :notice => 'el informe ha sido actualizado') and return  } 
      format.xml  { render :xml => @panelcontrol }
    end 
  end

  end

  def create_confirmation(token, description)
    con = Confirmation.create ({ :token => token, :description => description  })  
  end


  def getfutureproyectosactionresources(proyecto_id)  
    return Resource.find(:all , :include => :proyecto, :conditions=>["proyecto_id = ? AND controller = ?", proyecto_id, 'futureproyectosaction' ]  )
  end
  
  def getfutureproyectoaction(proyecto_id)    
    return Futureproyectosaction.find(:first, :include => :resources, :conditions=>["proyecto_id = ? ",proyecto_id])
  end   

  def conversor(ven)
    require 'yajl'
    json = StringIO.new(ven)
    parser = Yajl::Parser.new
    hash = parser.parse(json)
    total=0
    averange=''
    arr =[]

    if hash.length > 0
      hash.each  do |k|
        if  k.has_key?("proyecto")
          id = k["proyecto"]["id"]
          averange = k["proyecto"]["averange"]
          arr[id] == averange.to_f
          @h[id]  = k["proyecto"]["averange"].to_i if  !@h.has_key?( k["proyecto"]["id"])
          @ht[id] = k["proyecto"]["title"]         if  !@h.has_key?( k["proyecto"]["id"])
          @hid[id] = k["proyecto"]["id"]   if  !@h.has_key?( k["proyecto"]["id"])

          ac=@h[id]      
          ac = averange.to_f
          @h[id] = ac  if  @h.has_key?( k["proyecto"]["id"])
          @ht[id] = k["proyecto"]["title"] if @h.has_key?( k["proyecto"]["id"])
          @hid[id] = k["proyecto"]["id"]   if @h.has_key?( k["proyecto"]["id"]) 
          total += averange.to_f if (averange.to_f > 0)
        end
      end
    end
  end 


  def remove_files(dir, level=0)
    Dir["#{dir}/*"].each do |f|
      if File.directory?(f) then  
        scan_files(f, level+1)
      else    
        File.delete(f)      
      end
    end
  end


  def  create_up_history
    allproyects = Proyecto.all
    h2 =   allproyects.to_json
    date = DateTime.now
    v=  Document.last

    if  v ==  '' || v == nil
      doc = Document.create ({ :version => 1.0, :date => date  })
    else
      version = v.version.to_i + 1
      doc = Document.create ({ :version => version, :date => date  })
    end
    version=  Document.last
    bob = Historic.create ( {:snapshoot => allproyects.to_json.html_safe, :document_version => version.to_json} )

    respond_to do |format|
      format.html { redirect_to(panelcontrols_url) }
      format.xml  { render :xml => @panelcontrol }
    end
  end



  def confirm_token 
    date = DateTime.now
    @re = Confirmationuser.find(:first, :conditions => ['confirmation_token=? AND user_id=? AND user_token=?', 
                                 params[:token], params[:user_id], params[:user_token]])    
    respond_to do |format|
      if @re.update_attributes(:confirmed_at => date, :user_token => params[:user_token])
        format.html { redirect_to(panelcontrols_url, :notice => 'Confirmationuser was successfully updated.') }
        format.xml  { render :xml => @panelcontrol }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @panelcontrols.errors, :status => :unprocessable_entity }
      end
    end
  end  
  
  def usersconfirmpdf
    v=''
    vercreated_at=''
    verchangelog=''
    if (params[:doc])
      ver=params[:doc]      
      @last_doc_created_at=Document.last.created_at
      verchangelog=Document.last.changelog.to_s
      vercrated_at= @last_doc_created_at.strftime("%m/%d/%Y a las  %I:%M%p")    
    else
      @d=Document.last;
      ver=@d.version
      vercreated_at=@d.created_at
      verchangelog=Document.last.changelog.to_s
    end
    
    c=Confirmationuser.where("confirmation_token  LIKE  ? ", ver.to_s+'_%'  )
   
    confirma=''
    sinfirma=''
    html=''

    c.each do |n|
      if n.confirmed_at.nil? 
        confirmation_sent_at =  n.created_at.strftime("%m/%d/%Y a las  %I:%M%p")  if !n.created_at.nil?            
        sinfirma += '<li>'+User.find(n.user_id).email.to_s+' (Enviado: '+confirmation_sent_at.to_s+') </li>'
      end

      confirmed_at  =  n.updated_at.strftime("%m/%d/%Y a las  %I:%M%p")  if !n.confirmed_at.nil?   
      confirma += '<li>'+User.find(n.user_id).email.to_s+' (Confirmado: '+confirmed_at.to_s+')  </li>'   if !n.confirmed_at.nil?

    end  
        
    html += '<h1 class="titlepdf">Informe de confirmaciones del documento  '.to_s + ver +'</h1>'
    html += '<p>Creado el:'  + vercrated_at +  '</p>' if !vercrated_at.nil?
    html += '<p>Changelog:'  + verchangelog +  '</p>'
    html += '<h2>No han firmado el documento v.'.to_s + ver + '</h2>'.to_s
    html += '<frameset><ul>' +sinfirma+ '</ul>' if !sinfirma.nil?
    html += '<h2>Sí han firmado el documento</h2>'
    html += '<ul>' +confirma+ '</ul></frameset>'
    
    
    kit = PDFKit.new(html,  :orientation => 'Landscape', :footer_html => Rails.root.to_s + "/public/pdf/html/footer_pdf.html",  
                            :footer_line => true,  :header_html => Rails.root.to_s + "/public/pdf/html/header_pdf.html")
    kit.stylesheets << 'public/stylesheets/sentpdf.css'
        
    path="pdf/"

    if !File.directory?(path)
      Dir.mkdir(path,0777)
      FileUtils.chmod_R 0777, path
    end 
  
    path="pdf/create_pdf"
    
    if !File.directory?(path)
      Dir.mkdir(path,0777) 
      FileUtils.chmod_R 0777, path
    end
    
    FileUtils.rm Dir.glob('pdf/create_pdf/*')
  
    kit.to_file(path + '/confirmaciones_informe_v' + ver.to_s + '.pdf') 
    pa= path + '/confirmaciones_informe_v' + ver.to_s + '0.pdf'
    FileUtils.chmod_R 0777, path + '/confirmaciones_informe_v' + ver.to_s + '.pdf' if File.exist?(pa)
   
    out_data=path + '/confirmaciones_informe_v' + ver.to_s + '.pdf'
    return send_data File.read(out_data), :type => 'application/pdf', :filename => 'confirmaciones_informe_v' + ver.to_s + '0.pdf' , 
                                          :disposition=>'attachment' , :status=>'200 OK' , :stream=>true  

    respond_to do |format|      
      if request.xhr?
        format.js {render :partial => "usersconfirmpdf", :locals => { :notice => 'el informe ha sido actualizado' }, :content_type => 'text/javascript'}
      else  
        format.html { redirect_to(panelcontrols_url, flash[:notice] => 'Informe Pdf generado y enviado correctamente') } and return 
        format.xml  { render :xml => @panelcontrol }
      end
    end  
  end  
  
  def isconfirm(id_user, token)
  end


  def sendpdftousers
    doc= Document.last
    token=  doc.version.to_s+'_'+DateTime.now.to_s
    description='Nuevo Documento creado desde la funcion sendpdftousers en panelcontrols'
    create_confirmation(token, description)
    s=''
    us=User.find(:all)
    us.each do |v|      
      UserMailer.send_pdf( v.email.to_s,  s ,token).deliver
    end
  
    respond_to do |format|
      if request.xhr?
        format.js {render :partial => "sendpdftousers", :locals => { :notice => 'el informe ha sido enviado' }, :content_type => 'text/javascript'}
      else
        format.html { redirect_to(panelcontrols_url, flash[:notice] => 'Informe Pdf enviado correctamente') } and return
        format.xml  { render :xml => @panelcontrol }
      end
    end
  end  



  def getproyectos(es)
    Proyecto.find(:all , :include=> :futureproyectosaction, :conditions=>{:status=>es})
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
end
