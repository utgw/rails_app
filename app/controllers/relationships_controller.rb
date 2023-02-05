class RelationshipsController < ApplicationController
  def create
    follow = @current_user.active_relationships.build(follower_id: params[:user_id])
    follow.save!
    redirect_to("/users/#{params[:user_id]}")
  rescue StandardError
    flash[:notice] = 'ユーザーのフォローに失敗しました'
    redirect_to("/users/#{params[:user_id]}")
  end

  def destroy
    follow = @current_user.active_relationships.find_by!(follower_id: params[:user_id])
    follow.destroy!
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = 'このユーザーをフォローしていません'
  rescue StandardError
    flash[:notice] = 'ユーザーのアンフォローに失敗しました'
  ensure
    redirect_to("/users/#{params[:user_id]}")
  end
end
