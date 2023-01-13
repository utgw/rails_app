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
    @current_user_likes_post_ids = @current_user.likes.pluck(:post_id)
    @followings = @user.followings
    @followers = @user.followers
    @following_count = @followings.count
    @follower_count = @followers.count
  end

  def likes
    @user = User.find_by(id: params[:id])
    likes = Like.where(user_id: @user.id).order(created_at: :desc).pluck(:post_id)
    @like_posts = Post.includes([:user, :likes]).find(likes)
    @followings = @user.followings
    @followers = @user.followers
    @following_count = @followings.count
    @follower_count = @followers.count
  end

  def signup
  end

  def create
    @user = User.new(
      username: params[:username],
      email: params[:email],
      password: params[:password]
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました。"
      redirect_to("/users/#{@user.id}")
    else
      render :signup, status: :unprocessable_entity
    end
  end

  def edit
    @user =User.find_by(id: params[:id])
  end
  
  def update
    @user = User.find_by(id: params[:id])
    @user.username = params[:username]
    @user.email = params[:email]
    @user.password = params[:password]
    if params[:password] == params[:confirmPassword]
      if @user.save
        flash[:notice] = "ユーザー情報を変更しました"
        redirect_to("/users/#{@user.id}")
      else
        render :edit, status: :unprocessable_entity
      end
    else
      @error_message = "パスワードと確認用パスワードが違います"
      render :edit, status: :unprocessable_entity
    end
  end

  def login_form
  end 

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
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
end
