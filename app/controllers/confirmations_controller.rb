class ConfirmationsController < ApplicationController
  include Devise::Controllers::InternalHelpers

  # GET /resource/confirmation/new
  def new
    build_resource
    render_with_scope :new
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
      redirect_to new_session_path(resource_name)
    else
      render_with_scope :new
    end
  end

  # PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        @confirmable.attempt_set_password(params[:user])
        if @confirmable.valid?
          do_confirm
        else
          do_show
          @confirmable.errors.clear #so that we wont render :new
        end
      else
        self.class.add_error_on(self, :email, :password_allready_set)
      end
    end

    if !@confirmable.errors.empty?
      render_with_scope :new
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        do_show
      else
        do_confirm
      end
    end
    if !@confirmable.errors.empty?
      render_with_scope :new
    end
  end
  
  protected
  def with_unconfirmed_confirmable
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if !@confirmable.new_record?
      #@confirmable.only_if_unconfirmed {yield}
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render_with_scope :show
  end

  def do_confirm
    @confirmable.confirm!
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end
end
=begin

class ConfirmationsController < Devise::ConfirmationsController
  def show
    @account = User.find_by_confirmation_token(params[:confirmation_token])
    if !@account.present?
      render_with_scope :new
    end
  end

  def confirm_account
    @account = User.find(params[:confirmation_token])
    if @account.update_attributes(params[:account]) and @account.password_match?
      @account = User.confirm_by_token(@account.confirmation_token)
      set_flash_message :notice, :confirmed      
      sign_in_and_redirect("user", @account)
    else
      render :action => "show"
    end
  end

end

=end