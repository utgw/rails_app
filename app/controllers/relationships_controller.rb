class RelationshipsController < ApplicationController
  def create
    begin
      follow = @current_user.active_relationships.build(follower_id: params[:user_id])
      follow.save!
      redirect_to("/users/#{params[:user_id]}")
    rescue
      flash[:notice] = "ユーザーのフォローに失敗しました"
      redirect_to("/users/#{params[:user_id]}")
    end
  end

  def destroy
    begin
      follow = @current_user.active_relationships.find_by!(follower_id: params[:user_id])
      follow.destroy!
      redirect_to("/users/#{params[:user_id]}")
    rescue
      flash[:notice] = "ユーザーの安フォローに失敗しました"
      redirect_to("/users/#{params[:user_id]}")
    end
  end
end
