class ApplicationController < ActionController::Base
  before_action :set_current_user, :basic_auth

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def authenticate_user
    return unless @current_user.nil?

    flash[:notice] = 'ログインが必要です'
    redirect_to('/login')
  end

  def forbid_login_user
    return unless @current_user

    flash[:notice] = 'ログインしています'
    redirect_to('/posts/index')
  end

  def ensure_current_user
    return unless @current_user.id != params[:id].to_i

    flash[:notice] = '権限がありません'
    redirect_to('/posts/index')
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end
