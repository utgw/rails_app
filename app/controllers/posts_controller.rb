class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, { only: %i[edit update destroy] }

  def index
    @posts = Post.find_posts(@current_user, params[:page])
    @posts_liked_by_current_user = @current_user.likes.pluck(:post_id)
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  rescue StandardError
    flash[:notice] = '投稿の取得に失敗しました'
    redirect_to posts_index_path
  end

  def create
    @post = Post.create!(content: params[:content], user_id: @current_user.id)
    flash[:notice] = '投稿しました'
    redirect_to posts_index_path
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  rescue StandardError
    flash[:notice] = '投稿に失敗しました'
    redirect_to posts_index_path
  end

  def update
    @post = Post.find(params[:id])
    @post.update!(content: params[:content])
    flash[:notice] = '投稿を編集しました'
    redirect_to posts_index_path
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  rescue StandardError
    flash[:notice] = '投稿の編集に失敗しました'
    redirect_to posts_index_path
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy!
    flash[:notice] = '投稿を削除しました'
    redirect_back fallback_location: route_path
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = '削除する投稿が見つかりませんでした'
    redirect_back fallback_location: route_path
  rescue StandardError
    flash[:notice] = '投稿の削除に失敗しました'
    redirect_back fallback_location: route_path
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    return unless @current_user.id != @post.user_id

    flash[:notice] = '権限がありません'
    redirect_to('/posts/index')
  end

  private

  def post_params
    pramas.permit(:content)
  end
end
