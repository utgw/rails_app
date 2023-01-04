class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :delete]}


  def index
    @posts = Post.all.order(created_at: :desc)
  end
  def new
      @post = Post.new
  end
  def edit
    @post = Post.find_by(id: params[:id])
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
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def delete
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @current_user.id != @post.user_id
    flash[:notice] = "権限がありません"
    redirect_to("/posts/index")
    end
  end
end
