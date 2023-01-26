class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:show]}
  before_action :forbid_login_user, {only: [:login, :login_form, :signup, :create]}
  before_action :ensure_current_user, {only: [:edit, :update]}

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.includes(:likes).order(created_at: :desc).page(params[:page]).per(10)
    @posts_liked_by_current_user = @current_user.likes.pluck(:post_id)
    @followings = @user.followings
    @followers = @user.followers
    @following_count = @followings.count
    @follower_count = @followers.count
  end

  def likes
    @user = User.find_by(id: params[:id])
    @liked_posts = @user.liked_posts.includes([:user, :likes]).order("likes.created_at DESC").page(params[:page]).per(10)
    @posts_liked_by_current_user = @current_user.likes.pluck(:post_id)
    @followings = @user.followings
    @followers = @user.followers
    @following_count = @followings.count
    @follower_count = @followers.count
  end

  def signup
    @user = User.new
  end

  def create
    begin
      @user = User.new(user_params)
      @user.save!
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました。"
      redirect_to("/users/#{@user.id}")
    rescue ActiveRecord::RecordInvalid
      render :signup, status: :unprocessable_entity
    rescue
      flash[:notice] = "ユーザー登録に失敗しました"
      render :signup, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end
  
  def update
    begin
      @user = User.find(params[:id])
      @user.update!(user_params)
      flash[:notice] = "ユーザー情報を変更しました"
      redirect_to("/users/#{@user.id}")
    rescue ActiveRecord::RecordInvalid
      render :edit, status: :unprocessable_entity
    rescue
      flash[:notice] = "ユーザー情報の変更に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def login_form
  end 

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました。"
      redirect_to("/posts/index")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render :login_form, status: :unprocessable_entity
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました。"
    redirect_to("/login")
  end

  def follow
      user = User.find(params[:id])
      @users = user.followings
      @follows_count = @users.count
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
    @followers_count = @users.count
  end

  private
  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
