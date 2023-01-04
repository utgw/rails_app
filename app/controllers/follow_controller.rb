class FollowController < ApplicationController
    def create
        @follow = Follow.new(following_id: params[:id], follower_id: @current_user.id)
        @follow.save
        redirect_to("/users/#{params[:id]}")
    end

    def destroy
        @follow = Follow.find_by(following_id: params[:id], follower_id: @current_user.id)
        @follow.destroy
        redirect_to("/users/#{params[:id]}")
    end
  end
  