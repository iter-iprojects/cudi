class UserMailer < ActionMailer::Base

  @email=YAML.load_file(Rails.root.to_s+'/config/email.yml')

  default :from => @email['from']
 
  def welcome_email(user)
    mail(:to => user,
         :subject => "Test develop, subject - cudi",:mime_type => 'multipart/mixed'
	)
    mail.attachments.inline['allproyectsporqueno.pdf'] = File.read('public/pdf/allproyects.pdf')  if File.file?( 'public/pdf/allproyects.pdf' )
         	
    @user = user

  end

  def send_pdf(user,str,token)

    @email=YAML.load_file(Rails.root.to_s+'/config/email.yml')
    s=''
    u='' 
 
    date = DateTime.now 
    idu=''   
    ud=User.find(:all, :conditions=>{:email =>user})
    ud.each do|n|
      idu=n.id  
    end
    
  
    mail(:to => user
        )

    host = `hostname`.strip    

    t=Socket.gethostname

    li= @email['domainurl'] 	

    Dir.entries("public/pdf/create_pdf").each {|f|  

    u='public/pdf/create_pdf/' + f.to_s if  File.fnmatch('*ready_pdevelopers*', 'cudi/public/pdf/create_pdf/' +f.to_s)
       
    break if  File.fnmatch('*ready_pdevelopers*', 'cudi/public/pdf/create_pdf/' +f.to_s)

    }
    
    v= Document.last.version
    user_token=rand(36**59).to_s(36)
    Confirmationuser.create(:user_token=>user_token ,:user_id=> idu, :confirmation_token => token.to_s, :confirmation_sent_at => date, :document_id => v )
    
    
    attachments[u] = File.read(u)  if File.file?( u )
    
    subject = 'CUDI ------development unit, development document' + v.to_s 
    body =    "Hola, acabo de generar un nuevo documento, el nuevo versionado de este documento es "+v.to_s+" \r\n \n<br>"
    body +=   " \r\n Haciendo click en el siguiente enlace,   Apruebas el documento:"+v+
              '  <a href="http://'+li.to_s+'/confirm/'+token.to_s+'/'+idu.to_s+'/'+user_token+'">' + "APROBAR DOCUMENTO" + '</a>'  
    body +=   " \r\n<br> Un cordial saludo  \n  c.u.d.i."

    mail(:to => user, :subject => subject)  do |format|
   
    s += body	

    format.text { render :text => s.to_s }
    format.html { render :text => s.to_s }

    end
        
  end




  def send_new_proyect_pdf(user,str)
    mail(:to => user
    )

    attachments['allproyectsporqueno.pdf'] = File.read('public/pdf/allproyects.pdf')  if File.file?( 'public/pdf/allproyects.pdf' )
    v= Document.last.version

    subject = 'CUDI ------Unidad de Desarrollo, Se ha creado un nuevo proyecto en la version actual: v' + v
    mail(:to => user, :subject => subject)  do |format|

    t=Socket.gethostname

    filename=File.basename("/public/pdf/create_pdf/")
   
    s='http://' + t  + 'cudi/public/pdf/create_pdf' + filename.to_s        
    
    format.text { render :text => s.to_s }
    format.html { render :text => s.to_s }
    end
  end
  
  
  
  def sendtmp_email_file(user, filename, sub, bod)

    s=sub
    u=''    
    idu=''   
    ud=User.find(:all, :conditions=>{:email =>user})
    ud.each do|n|
      idu=n.id  
    end

    mail(:to => user
    )

    host = `hostname`.strip    
    t=Socket.gethostname
    li=local_ip

    u= filename.to_s if File.exist?(filename.to_s) 

    attachments[u] = File.read(u)  if File.file?( u )
    File.delete(filename.to_s) if File.exist?(filename.to_s) 
    v= Document.last.version
    subject = s   
    body=  bod.to_s 
 
    mail(:to => user, :subject => sub)  do |format|
   
    s += body  

    format.text { render :text => s.to_s }
    format.html { render :text => s.to_s }

    end
    

  end



    def send_email_file(user, filename, sub, bod)

    s=''
    u='' 
  
    idu=''   
    ud=User.find(:all, :conditions=>{:email =>user})
    ud.each do|n|
      idu=n.id  
    end

    mail(:to => user
    )

    host = `hostname`.strip    
    t=Socket.gethostname
    li=local_ip


    u='public/pdf/create_pdf/' + filename.to_s if File.exist?('public/pdf/create_pdf/'+filename.to_s) 


    attachments[u] = File.read(u)  if File.file?( u )
    File.delete('public/pdf/create_pdf/'+filename.to_s) if File.exist?('public/pdf/create_pdf/'+filename.to_s) 

    v= Document.last.version
    subject = 'CUDI ------Unidad de Desarrollo, Documento de Coordinacion v' + v 
   
    body=  bod.to_s 
 
    mail(:to => user, :subject => sub)  do |format|
   
       s += body  

    format.text { render :text => s.to_s }
    format.html { render :text => s.to_s }

    end
    

  end



  def local_ip
    require 'socket'
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
    ensure
    Socket.do_not_reverse_lookup = orig
  end

end

