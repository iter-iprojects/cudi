class SessionsController < Devise::SessionsController

  def create
    @userinfo = Array.new
    @userinfo=validausuarios(params)
     if @userinfo['bind']=="false"
     end
      
    if  @userinfo['bind']=="true" 
      un=User.find(:all, :conditions => { :username => @userinfo["uid"][0]})
      @usernow=User.find(:all, :conditions => { :username => @userinfo["uid"][0]})
      

        if un==[] 
            uy = User.create! do |u|
            u.username = @userinfo["uid"][0]
            u.password = params['user']['password']
                    
            u.email    = @userinfo["mail"][0]
            u.ou = @userinfo["ou"][0]
            u.cn = @userinfo["cn"][0]
            u.telephonenumber = @userinfo["telephonenumber"][0] if @userinfo["telephonenumber"][0]
            
            displayn= Array.new()
             if defined?(@userinfo["displayname"][0])
                u.displayname = @userinfo["displayname"][0] 
                displayn[0]= @userinfo["displayname"][0]
             else

                u.displayname=u.cn.to_s 
             end
           end
        else
 
	  @usernow.each do |r|
           completando		if r.displayname.empty?	
	   end		
	  

        end

          flash[:notice] = "Bienvenido"         
    else
       
      end  
      super 
  end


  def completando

    displayn= @userinfo["cn"][0] if  !@userinfo.include? 'displayname'
    displayn= @userinfo["displayname"][0] if  @userinfo.include? 'displayname'
    euid=''

    @usernow.each do |b|
      euid=b.id
    end

    User.find(euid).update_attributes(:displayname => displayn , :telephonenumber => @userinfo["telephonenumber"][0], :email =>  @userinfo["mail"][0], :cn => @userinfo["cn"][0] )

  end	


  def destroy
    logger.info "#{ current_user.email } signed out"
    super
    redirect_to proyecto_path
  end
  
  
  def validausuarios(params)

    require 'yaml'

    ldapconf=YAML.load_file(Rails.root.to_s+'/config/ldap.yml')
        
    require 'rubygems'
    require Rails.root.to_s+'/vendor/plugins/net/ldap'
    ldap = Net::LDAP.new :host => ldapconf['host'],
     :port => ldapconf['port'],
     :auth => {
     :method =>  :simple,
     :username => "uid="+params[:user][:username]+ldapconf['chainconection'],
     :password => params[:user][:password]

     }

     ldap.bind
     
     filter = Net::LDAP::Filter.eq("uid",params[:user][:username])&  Net::LDAP::Filter.eq("mail","*")#(&(objectClass=sambaSamAccount)(accountStatus=active)
     treebase = "ou=Users,dc=iter,dc=es"

     recoge=''
     json = Array.new
     h = Hash.new()

     h['bind']=ldap.bind.to_s  
     ldap.search( :base => treebase,  :filter => filter ) do |entry|
       json[1]= entry.mail.to_s
       json[2]= entry.uid.to_s
       json[3]= entry.ou.to_s
       json[4]= entry.cn.to_s
       json[5]= entry.gidnumber

       entry.each do |attribute, values|
         h["#{attribute}"]=values
       end
     end
    return h
  end
 
  def createusersys
    User.create_if_not_exist(:username => @userinfo['uid'], :email => @userinfo['mail'], :ou => @userinfo['ou'])
  end
    
  def updateifchange

    u =  @usernow     
    @usernow.each do |d|
      d.email="si me deja"
    end

    @usernow.update_attributes(:email=>'je a sort')
  end
end
