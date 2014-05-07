class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :after_token_authentication # it is empty hook provided by devise i,e

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end


  def after_token_authentication
    if params[:authentication_key].present?
      @user = User.find_by_authentication_token(params[:authentication_key])
      sign_in @user if @user
      redirect_to root_path
    end
  end
  
  def is_admin
   if  current_user.has_role? :admin
    return true
  else
    redirect_to root_path, :alert => 'You do have permission to this page'
  end
  end
end
