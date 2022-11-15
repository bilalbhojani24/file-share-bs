class UserController < ApplicationController

  def new
    @user = User.new
  end

  def sign_up
    @user = User.new
  end

  def sign_up!
    @user = User.new(
      name: params[:name],
      email: params[:email],
      username: params[:username],
      password_digest: BCrypt::Password.create(params[:password_digest])
    )

    respond_to do |format|
      if params[:password_digest].length < 8
        handle_error(format, :sign_up, "Password is short", "password")
      elsif !params[:password_digest].match(/(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*/)
        handle_error(format, :sign_up, "Password must contain one uppercase, lowercase and number", "password")
      elsif @user.save
        format.html { redirect_to "/" }
        format.json { render :show, status: :created, location: @user }
        session[:user] = @user.id
      else
        handle_error(format, :sign_up, "Something went wrong!", "password")
      end
    end
  end

  def sign_in
    @user = User.new
  end

  def sign_in!
    @user = User.find_by(username: params[:username])

    respond_to do |format|
      if !@user
        puts "No user found!!!"
        flash[:notice] = "Username is incorrrect"
        redirect_to "/sign_in"
        # handle_error(format, :sign_up, "User does not exist!", "password")
      elsif !BCrypt::Password.new(@user.password_digest).is_password?(params[:password])
        handle_error(format, :sign_up, "Password is incorrect", "password")
      else
        session[:user] = @user.id
        format.html { redirect_to "/" }
        format.json { render :show, status: :created, location: @user }
      end
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
  def handle_error (format, _path, message, field)
    @user.errors.add(:field, message)
    format.html { render _path, status: :unprocessable_entity }
    format.json { render json: @user.errors, status: :unprocessable_entity }
  end

end
