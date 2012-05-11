# coding: utf-8
class CudidocsController < ApplicationController

  skip_before_filter :only_authenticated_users_are_welcome, :except => [:datasheetsave, :getHtml, :publicdocs]

  def index
    @cudidocs = Cudidoc.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cudidocs }
    end
  end
  

  def datasheetsave

    respond_to do |format|
        
    if request.xhr?     

      vc=Cudidoc.find(params['fid']) if !params['fid']== ''       
      nui= params['fid'].gsub(/"/, '')                     

      buffer=''
      buffer = Hpricot.parse(params['contain'])
         
      local_filename=''
      directory_name = Rails.root.to_s  + '/'.to_s +  'usersdoc'.to_s
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      directory_user = Rails.root.to_s  + '/'.to_s + 'usersdoc'.to_s + '/'.to_s +  current_user.id.to_s
      Dir.mkdir(directory_user) unless File.exists?(directory_user)
          
      vra=''
      vra=  rand(35435234534534).to_s.chop 
                     
      if nui == ""         
        file_user_save =   vra.to_s + '.html'.to_s   if nui== ""
        c = Cudidoc.new(:namefile => 'new_file', :user_id => current_user.id,  :public => 'checked' )
        file_user = directory_user  + '/'.to_s +  vra.to_s  + '.html'.to_s
        c.update_attributes!(:contain =>   vra.to_s  + '.html'.to_s , :namefile => params['fn'])            
      end
          
      if params['fid'].to_i > 0 || nui.to_i > 0

        c =  Cudidoc.find_by_id_and_user_id(  nui  ,  current_user.id.to_s )
        if (c.nil?)
          file_user_save =   vra.to_s + '.html'.to_s   if nui== ""
          c = Cudidoc.new(:namefile => 'new_file', :user_id => current_user.id,  :public => 'checked' )
          file_user = directory_user  + '/'.to_s +  vra.to_s  + '.html'.to_s
          c.update_attributes!(:contain =>   vra.to_s  + '.html'.to_s , :namefile => params['fn'], :public => 'checked')
        else  
          c.update_attributes!(:contain =>   c.contain.to_s , :namefile => params['fn'], :public => 'checked')
          file_user = directory_user  + '/'.to_s +  c.contain.to_s
        end    
      end

      File.open(file_user, 'w') {|f| f.write(buffer) }
          
                     
      alldoc=Cudidoc.where(:user_id => current_user.id.to_s)

      format.js {render :partial => "datasheetsave", :locals => { :notice => 'el informe ha sido enviado', :shtml => c, :alldoc => alldoc }, :content_type => 'text/javascript'}
        else 
        end
    end  
  end  

  def getHtml
    v=Cudidoc.find(:first, :conditions=>{:id=> params['id']});
      respond_to do |format|
        if request.xhr?

          s=''        
          p =  Rails.root.to_s + '/'.to_s    +   'usersdoc'.to_s + '/'.to_s    + current_user.id.to_s + '/'.to_s + v.contain.to_s
          if !File.exist?(p)
            return false
          end
           
          handle = File.open(p,"r")
          handle.lines.each do |line|
            s += line.chomp 
          end
          handle.close

          v.contain = s
          v.contain = CGI::unescape(v.contain)
              
          alldoc=Cudidoc.where(:user_id => current_user.id.to_s)
          format.js {render :partial => "getHtml", :locals => { :notice => 'poner lo que proceda', :shtml => v, :alldoc => alldoc  }, :content_type => 'text/javascript'}
      end
    end      
  end


  def getalldocs
    respond_to do |format|
      if request.xhr?
        otheruserdoc=Cudidoc.find(:all, :conditions => "user_id <> " + current_user.id.to_s  + " AND public = 'checked'")
        alldoc=Cudidoc.where(:user_id => current_user.id.to_s)
          
        alldoc.each do |v|
          if (v.public.to_s != 'checked')
            v.public='false';
            v.user_id=User.find(:first).username
          end
        end     
        format.js {render :partial => "getalldocs", :locals => { :notice => 'poner lo que proceda',  :alldoc => alldoc, :otheruserdoc => otheruserdoc  }, :content_type => 'text/javascript'}
      end
    end    
  end



  def getallpublicdocs
    respond_to do |format|
      if request.xhr?     
        alldoc=Cudidoc.find(:all, :conditions => "public = 'false'")
               
        alldoc.each do |v|
          if (v.public.to_s != 'checked')
            v.public='false';
            v.user_id=User.find(:first).username
          end
        end
     
        format.js {render :partial => "getallpublicdocs", :locals => { :notice => 'poner lo que proceda',  :alldoc => alldoc  }, :content_type => 'text/javascript'}
      end
    end    
  end




  def erasedocs
    respond_to do |format|
      if request.xhr?
        a=params['myA']
        
        a.each do |v|
             
          s=v.split ','
          cd=Cudidoc.find(:first, :conditions => {:id => s});
          directory_user = Rails.root.to_s  + '/'.to_s + 'usersdoc'.to_s + '/'.to_s +  current_user.id.to_s
          file_user = directory_user  + '/' +  cd.contain.to_s.chop 
      
          File.delete(file_user) unless !File.exists?(file_user)                
          Cudidoc.delete(v.split ',')        
        end

        alldoc=Cudidoc.where(:user_id => current_user.id.to_s)
        alldoc.each do |v|
          if (v.public.to_s != 'checked')
            v.public='false';
          end
        end
                    
        format.js {render :partial => "getalldocs", :locals => { :notice => 'poner lo que proceda',  :alldoc => alldoc  }, :content_type => 'text/javascript'}
      end
    end   
  end


  def publicdocs
    respond_to do |format|
      if request.xhr?
        a=params['myA']        
        a= a[0]         
        a= a.split(',')

        a.each do |v|

          cd=Cudidoc.find(:first, :conditions => {:id => v });

          if (cd.public == 'checked')
            cd.update_attributes!(:public => 'false')
          else 
            cd.update_attributes!(:public => 'checked') 
          end
     
        end
        
        alldoc=Cudidoc.where(:user_id => current_user.id.to_s)
        alldoc.each do |v|
          if (v.public.to_s != 'checked')
            v.public='false';
          end
        end
       
        format.js {render :partial => "getalldocs", :locals => { :notice => 'poner lo que proceda',  :alldoc => alldoc  }, :content_type => 'text/javascript'}
      end
    end   
  end


  def sendpdf
  
    path=Rails.root.to_s+"/tmp/pdf/"
    Dir.mkdir(path,755) if !File.directory?(path)
  
    htm =  params['ht']
    asu =  params['asu']

    t = Time.now
    fe=t.strftime(" process:  %m/%d/%Y at %I:%M%p") 

    ac=0
    acs=''
    c=0

    htm.each_line do |line|  
      acs += line.to_s  if (c > 237)
      c += 1
    end

    acs = asu + acs + '<br>From  es.cudi.doc   cudi <br>'
 
    kit = PDFKit.new( acs ,  :orientation => 'Landscape', :header_spacing=>26, :footer_html => Rails.root.to_s+"/public/pdf/html/footer_pdf.html", 
                             :footer_line => true,   :header_html => Rails.root.to_s+"/public/pdf/html/header_pdf.html" )
    kit.stylesheets << 'public/stylesheets/jquery_sheet/jquery.sheet.css'
    kit.to_file(path.to_s + current_user.id.to_s + 'temporaluser.pdf') 
    
    fl=path.to_s + current_user.id.to_s + 'temporaluser.pdf'
  
  
    subject='cudi.es.doc' + current_user.email.to_s + ' from cudi ' + fe 
    body='The users: ' + current_user.email.to_s  +  ' send a file for you' 

    UserMailer.sendtmp_email_file(params['em'].to_s , fl , subject.to_s, body.to_s).deliver
  
      respond_to do |format|
        if request.xhr?
          format.js {render :partial => "sendpdf", :locals => { :notice => 'enviado correctamente' }, :content_type => 'text/javascript'}
        end
       end 
  
  end


  def updatetitles

    v=Cudidoc.find(:all, :conditions=>{:user_id=> current_user.id});
      respond_to do |format|
        if request.xhr?
          format.js {render :partial => "updatetitles", :locals => { :notice => 'poner lo que proceda', :shtml => v }, :content_type => 'text/javascript'}
        end
      end      

  end

  def show
    @cudidoc = Cudidoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cudidoc }
    end
  end


  def new
    @cudidoc = Cudidoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cudidoc }
    end
  end


  def edit
    @cudidoc = Cudidoc.find(params[:id])
  end


  def create
    @cudidoc = Cudidoc.new(params[:cudidoc])

    respond_to do |format|
      if @cudidoc.save
        format.html { redirect_to @cudidoc, notice: 'Cudidoc was successfully created.' }
        format.json { render json: @cudidoc, status: :created, location: @cudidoc }
      else
        format.html { render action: "new" }
        format.json { render json: @cudidoc.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @cudidoc = Cudidoc.find(params[:id])

    respond_to do |format|
      if @cudidoc.update_attributes(params[:cudidoc])
        format.html { redirect_to @cudidoc, notice: 'Cudidoc was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @cudidoc.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @cudidoc = Cudidoc.find(params[:id])
    @cudidoc.destroy

    respond_to do |format|
      format.html { redirect_to cudidocs_url }
      format.json { head :ok }
    end
  end
  
  def enduserspreeadsheet
    respond_to do |format|
      if request.xhr?
        format.js {render :partial => "enduserspreeadsheet", :locals => { :notice => 'enviado correctamente', :shtml => 'aqui el fichero html' }, :content_type => 'text/javascript'}
      end
    end  
  end
  
end
