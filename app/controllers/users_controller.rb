class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_current_user

  def index
    @users = User.all.paginate(page: params[:page])
    @microposts = current_user.microposts.between_times(Time.zone.now - 1.month, Time.zone.now)
    @following_users = current_user.active_relationships.between_times(Time.zone.now - 1.month, Time.zone.now)
    @followed_users = current_user.passive_relationships.between_times(Time.zone.now - 1.month, Time.zone.now)

    respond_to do |format|
      format.html
      format.zip do
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          zos.put_next_entry "microposts.csv"
          zos.print @microposts.to_csv

          zos.put_next_entry "following_users.csv"
          zos.print @following_users.to_csv("following")

          zos.put_next_entry "follower_users.csv"
          zos.print @followed_users.to_csv("followed")
        end
        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: "activity_log.zip"
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:infor] = "Please check email to activate account"
      redirect_to root_url
    else
      render "new"
    end
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_current_user
    @current_user = current_user
  end
end
