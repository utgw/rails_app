class LikesController < ApplicationController
    def like
        like = Like.new(user_id: @current_user.id, post_id:params[:id])
    end
    
    def destroy
        
    end
end