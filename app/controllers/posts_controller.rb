class PostsController < ApplicationController
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
      @post = Post.new(content: params[:content])
      if @post.save
        flash[:notice] = "Your post was sent."
        redirect_to("/posts/index")
      else
        render :new, status: :unprocessable_entity
      end
  end
  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "Your post was edited."
      redirect_to("/posts/index")
    else
      render("posts/#{@post.id}/edit")
    end
  end
  def delete
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "Your post was deleted."
    redirect_to("/posts/index")
  end
end
