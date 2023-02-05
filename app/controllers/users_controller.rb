class UsersController < ApplicationController
  before_action :authenticate_user, { only: %i[show] }
  before_action :forbid_login_user, { only: %i[login login_form signup create] }
  before_action :ensure_current_user, { only: %i[edit update] }
  before_action :get_following_users_and_followers, { only: %i[show likes] }

  def index
    @users = User.all
  end

  def show
    @posts = @user.find_posts(params[:page])
    @posts_liked_by_current_user = @current_user.likes.pluck(:post_id)
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = '該当のユーザーが見つかりませんでした'
    redirect_to users_index_path
  rescue StandardError
    flash[:notice] = 'プロフィール画面の表示に失敗しました'
    redirect_to users_index_path
  end

  def likes
    @liked_posts = @user.find_liked_posts(params[:page])
    @posts_liked_by_current_user = @current_user.likes.pluck(:post_id)
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = '該当のユーザーが見つかりませんでした'
    redirect_to users_index_path
  rescue StandardError
    flash[:notice] = 'いいね一覧の表示に失敗しました'
    redirect_to users_index_path
  end

  def signup
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save!
    session[:user_id] = @user.id
    flash[:notice] = 'ユーザー登録が完了しました。'
    redirect_to("/users/#{@user.id}")
  rescue ActiveRecord::RecordInvalid
    render :signup, status: :unprocessable_entity
  rescue StandardError
    flash[:notice] = 'ユーザー登録に失敗しました'
    redirect_to users_index_path
  end

  def edit
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = '該当のユーザーが見つかりませんでした'
    redirect_to users_index_path
  rescue StandardError
    flash[:notice] = 'ユーザーの表示に失敗しました'
    redirect_to users_index_path
  end

  def update
    @user = User.find(params[:id])
    @user.update!(user_params)
    flash[:notice] = 'ユーザー情報を変更しました'
    redirect_to("/users/#{@user.id}")
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = '該当のユーザーが見つかりませんでした'
    redirect_to users_index_path
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  rescue StandardError
    flash[:notice] = 'ユーザー情報の更新に失敗しました'
    redirect_to users_index_path
  end

  def login_form; end

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = 'ログインしました。'
      redirect_to('/posts/index')
    else
      @error_message = 'メールアドレスまたはパスワードが間違っています'
      @email = params[:email]
      @password = params[:password]
      render :login_form, status: :unprocessable_entity
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'ログアウトしました。'
    redirect_to('/login')
  end

  def follow
    user = User.find(params[:id])
    @users = user.followings
    @follows_count = @users.count
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = '該当のユーザーが見つかりませんでした'
    redirect_to users_index_path
  rescue StandardError
    flash[:notice] = 'フォロー一覧の表示に失敗しました'
    redirect_to users_index_path
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
    @followers_count = @users.count
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = '該当のユーザーが見つかりませんでした'
    redirect_to users_index_path
  rescue StandardError
    flash[:notice] = 'フォロワー一覧の表示に失敗しました'
    redirect_to users_indext_path
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

  def find_following_users_and_followers
    @user = User.find(params[:id])
    @followings = @user.followings
    @followers = @user.followers
    @following_count = @followings.count
    @follower_count = @followers.count
  end
end
