# encoding: UTF-8
class ApplicationController < ActionController::Base
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end


  before_filter :authenticate_user!, :except => [:checkinstall, :datasheetsave, :getHtml]
  before_filter :adjust_format_for_iphone


  def adjust_format_for_iphone
    if request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|iPad)/]
      request.format = :iphone 
    end
  end


  after_filter :user_activity
  private

  def user_activity
  end


  def index
    @particular_items  = []
    @users = User.all
    @roles = Role.all
    @roleuser = Roles_user.find(:all, :conditions => "user_id =" + current_user.id.to_s)
    @roleuser.each do |r|
      @actualrole=r.role_id
    end
  end


  def routepublic        
    redirect_to publicproyecto_index_path, :id => "lavariablequellerre"
  end

  class AbstractRequest
    def iphone?
      self.env["HTTP_USER_AGENT"] && self.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
    end
  end
  protected

  def require_admin!
    unless current_user.try :is_admin?
    redirect_to root_path, :alert => "Access Denied"
    end
  end

end
