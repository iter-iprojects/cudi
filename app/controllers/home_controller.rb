# encoding: UTF-8
class HomeController < ApplicationController
		
  def index    
    date = DateTime.now    
    documentnow = Document.last  
   
    @documentnow= 'Es la primera vez que entras en cudi, por favor ejecuta rake cudi:setup en línea de comandos'  if  Document.count < 1
    @documentdate=  documentnow.date.strftime("%m/%d/%Y a las  %I:%M%p")   if Document.count  > 0 
    @documentnow= documentnow.version if Document.count > 0
    

    @proyectosini = Proyecto.all
    @users = User.all
    ausers = User.all	

    @proyectostatus = 'all' 
    @proyectostatus = params[:listby] if params[:listby]    
   
    escaped_snapshoot =  '[{"proyecto'
    @Historics = Historic.find(:all, :order => "created_at desc", :limit => 2, :conditions=> ["snapshoot like ?", escaped_snapshoot + "%"] )		
    create_up_history if @Historics.count < 1 		
    histo3 = []

    @mira=''
    @porta=''
    ven=''
    @h = Hash.new()
    @ht = Hash.new()
    @h1 = Hash.new()
    @h2 = Hash.new()
    
    nh= @Historics.count()
    n=1 
    create_graph
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
          ac=@h[id]

          ac = averange.to_f
          @h[id] = ac  if  @h.has_key?( k["proyecto"]["id"]) 
          @ht[id] = k["proyecto"]["title"] if @h.has_key?( k["proyecto"]["id"])			
          total += averange.to_f if (averange.to_f > 0)
        end
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
      format.html { redirect_to(panelcontrols_url) } and return
      format.xml  { render :xml => @panelcontrol }
    end  
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

    g = Gruff::Bar.new('600x300')
    g.title = "Seguimiento de Proyectos Activos"

    g.theme = {
                :colors => %w(#e8e8e8 #dfdfdf #d0d0d0  #c0c0c0  #869023  ),
                :marker_color => '#aaa',
                :background_colors => %w(#fff  #ececec  ),
                :background_image => ''
    }

    proyectosactuales=Proyecto.find(:all,:conditions => ["status='1'"])

    @s= Hash.new
    @i= []
    n=1
    ticks=''
    proyectosactuales.each do |pa|      
      ticks += ',' + "'" + pa.title.to_s + "'" if  n != 1
      ticks += "'" + pa.title.to_s + "'" if  n == 1

      sn= pa.title.to_s  
      @i.push(pa.id.to_s)
      n += 1
    end

    c=1
    shisto=[]
    sdoc= Hash.new
    ave=[]
    ve=''
    @labels= Hash.new

    n=5
    nl=1
    n=Historic.count if Historic.count < n

    is_well_format_historic

    if n >= 5

      Historic.last(5).each do |histo|

      shisto = ActiveSupport::JSON.decode(histo.snapshoot) if !histo.snapshoot.nil?
      sdoc   =   ActiveSupport::JSON.decode(histo.document_version) #if ! histo.document_version.nil?

      ve =   "v" + sdoc["document"]["version"].to_s
      @labels[nl] =  "v" + sdoc["document"]["version"].to_s
      nl += 1  
      aAVE=[]
      @i.each {|pid|
        sAVE='0'
        shisto.select {|v|
          sAVE = v["proyecto"]["averange"].to_s  if pid.to_s == v["proyecto"]["id"].to_s
        }
        aAVE.push(sAVE.to_i)
      }


      g.data(ve, aAVE)
      ct=1   

      @s.each do |k,v|
        ct +=1
      end   
  

      @h1s = aAVE if c == 1
      @h2s = aAVE if c == 2
      @h3s = aAVE if c == 3
      @h4s = aAVE if c == 4 
      @h5s = aAVE if c == 5

      c +=1
    end

    @hts = "[" + ticks.gsub('"', "") + "];"
   end
   @msg= n.to_s + ' Históricos no son suficientes para mostrar la gráfica comparativa de 5 versiones ' if n < 5 
end

  def is_well_format_historic
    return false   if Historic.count < 5 
    tshisto=[]
    tsdoc= Hash.new  
    Historic.last(5).each do |histo|
      return false      if histo.snapshoot.nil?
      tshisto = ActiveSupport::JSON.decode(histo.snapshoot) if !histo.snapshoot.nil?
      tsdoc   =   ActiveSupport::JSON.decode(histo.document_version)     
    end      
  end 
 

  def listpdffiles
    path=Rails.root.to_s+"/historydocs"
    s='<div id="Full-Historico"><h1>Listado hist&oacute;rico</h1><a id="CerrAr" onclick="cerrarfullscreen()" >Close</a><div id="pdful">'
    @files = Dir.glob("historydocs/*.pdf")   
    sorted= @files.sort_by {|filename| File.mtime(filename) }
    for file in sorted.reverse_each
      cs='onclick=showpdf("'+File.basename(file)+'")'.to_s        
      s +=  '<a class="showPDF"'.to_s  + cs +'>'.to_s + File.basename(file).to_s + '</a>'
    end
                  
    respond_to do |format|
      if request.xhr?
        format.html
        format.xml
        format.js {render :partial => "listpdffiles", :locals => { :notice => 'poner lo que proceda', :shtml => s }, :content_type => 'text/javascript'}
      else
      end  
    end      
  end 

  def showpdf
    if !params[:fn].nil? && params[:fn].scan('historic').size==1
      out_data=Rails.root.to_s+"/historydocs/" + params[:fn].to_s
      send_data File.read(out_data), :type => 'application/pdf', :filename => params[:fn].to_s  , :disposition=>'attachment' , :status=>'200 OK' , :stream=>true  
    end
  end   

end
