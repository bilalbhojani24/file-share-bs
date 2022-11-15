class UserController < ApplicationController

  def new
    @user = User.new
  end

  def sign_up
    @user = User.new
  end

  def sign_up!
    @user = User.new(
      name: user_params[:name],
      email: user_params[:email],
      username: user_params[:username],
      password_digest: BCrypt::Password.create(user_params[:password_digest])
    )
    
    if user_params[:password_digest].length < 8
      @user.errors.add(:password_digest, "Passwors is short")
      flash[:messages] = @user.errors
      redirect_to :sign_up
    elsif !user_params[:password_digest].match(/(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*/)
      @user.errors.add(:password_digest, "Password must contain one uppercase, lowercase and number")
      flash[:messages] = @user.errors
      redirect_to :sign_up
    elsif @user.valid?
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
    if @user && BCrypt::Password.new(@user.password_digest).is_password?(user_params[:password_digest])
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
        params.require(:user).permit(:username, :name, :email, :password_digest)
    end

end
