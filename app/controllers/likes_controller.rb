class LikesController < ApplicationController
    def create
        begin
            @like = Like.new(user_id: @current_user.id, post_id:params[:post_id])
            @like.save!
            redirect_back fallback_location: route_path
        rescue
            flash[:notice] = "いいねに失敗しました"
            redirect_back fallback_location: route_path
        end
    end
    
    def destroy
        begin
            @like = Like.find_by!(user_id: @current_user.id, post_id:params[:post_id])
            @like.destroy!
            redirect_back fallback_location: route_path
        rescue ActiveRecord::RecordNotFound
            flash[:notice] = "この投稿にいいねをしていません"
        rescue
            flash[:notice] = "いいねの取り消しに失敗しました"
            redirect_back fallback_location: route_path
        end
    end    
end