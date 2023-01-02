class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def signup
  end

  def login_form
  end 
  def login
  end
end
