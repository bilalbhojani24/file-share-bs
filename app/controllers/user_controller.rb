class UserController < ApplicationController

  def new
    @user = User.new
  end

  def sign_up
    @user = User.new
  end

  def sign_up!
    @user = User.new(user_params)
    
    if @user.valid?
      @user.save
      session[:user] = @user.id
      redirect_to "/"
    else
      flash[:messages] = @user.errors
      redirect_to :sign_up
    end
  end

  def sign_in
    @user = User.new
  end

  def sign_in!
    @user = User.find_by(username: user_params[:username])
    if @user && @user.authenticate(user_params[:password])
        session[:user] = @user.id
        redirect_to "/"
    else
        flash[:messages] = "Username or Password incorrect! Please try again"
        redirect_to "/sign_in"
    end
  end

  def update
    @user = User.find_by(username: params[:username])
  end

  def update!
    @user = User.find_by(username: params[:username])
    @user.update(name: params[:name], email: params[:email])
    flash[:notice] = "Profile updated!"
    redirect_to "/update/#{current_user.username}"
  end

  def sign_out
    reset_session
    redirect_to "/"
  end

  # Helper function for error handling
  def handle_error (message, redirect)
    flash[:notice] = message
    redirect_to redirect
  end

  private
    def user_params
        params.require(:user).permit(:username, :name, :email, :password)
    end

end
