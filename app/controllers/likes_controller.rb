class LikesController < ApplicationController
    def create_in_home
        @like = Like.new(user_id: @current_user.id, post_id:params[:post_id])
        @like.save
        redirect_to("/posts/index")
    end
    
    def destroy_in_home
         @like = Like.find_by(user_id: @current_user.id, post_id:params[:post_id])
         @like.destroy
        redirect_to("/posts/index")
    end
    def create_in_profile
        @like = Like.new(user_id: @current_user.id, post_id:params[:post_id])
        @like.save
        redirect_to("/users/#{@current_user.id}")
    end
    
    def destroy_in_profile
         @like = Like.find_by(user_id: @current_user.id, post_id:params[:post_id])
         @like.destroy
        redirect_to("/users/#{@current_user.id}")
    end
    
end