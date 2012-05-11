class UsersController    < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:notice] = "Account registered! desde users_controller"        
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end



  def setup_role
    if self.role_id.empty?
      self.role_id = [2]
    end
  end

  # Get roles accessible by the current user
  #----------------------------------------------------
  def accessible_roles
    @accessible_roles = Role.accessible_by(current_ability,:read)
  end
 
  # Make the current user object available to views
  #----------------------------------------
  def get_user
    @current_user = current_user
  end

  def usersonline    

    s=''  
    users = User.find(:all, :conditions => ["updated_at > ?", Time.now - 10.minutes]) 
  
    users.each do |v|
      s += "<div>".to_s + v.email  + "</div>"
    end
    
    respond_to do |format|
      if request.xhr?
        format.js {render :partial => "usersonline", :locals => { :notice => 'poner lo que proceda', :shtml => s }, :content_type => 'text/javascript'}
      end
    end   
  end


end
