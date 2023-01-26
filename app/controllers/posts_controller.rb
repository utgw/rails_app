class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}


  def index
    @posts = Post.where(user_id: [@current_user.id, *@current_user.followings]).order(created_at: :desc).page(params[:page]).per(10)
    @posts_liked_by_current_user = @current_user.likes.pluck(:post_id)
  end

  def new
      @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
      @post = Post.new(
        content: params[:content], 
        user_id: @current_user.id
      )
      if @post.save
        flash[:notice] = "投稿しました"
        redirect_to("/posts/index")
      else
        render :new, status: :unprocessable_entity
      end
  end
  
  def update
    begin
      @post = Post.find(params[:id])
      @post.content = params[:content]
      @post.save!
        flash[:notice] = "投稿を編集しました"
        redirect_to posts_index_path
    rescue ActiveRecord::RecordInvalid
      render :edit, status: :unprocessable_entity
    rescue
      flash[:notice] = "投稿の編集に失敗しました" 
      redirect_to posts_index_path
    end
  end

  def destroy
    begin
      @post = Post.find(params[:id])
      @post.destroy!
      flash[:notice] = "投稿を削除しました"
      redirect_back fallback_location: route_path
    rescue 
      flash[:notice] = "投稿の削除に失敗しました"
      redirect_back fallback_location: route_path
    end
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    if @current_user.id != @post.user_id
    flash[:notice] = "権限がありません"
    redirect_to("/posts/index")
    end
  end
end
