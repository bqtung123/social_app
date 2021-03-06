class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_current_user

  def index
    @users = User.all.paginate(page: params[:page])
    @microposts = current_user.microposts.between_times(Time.zone.now - 1.month, Time.zone.now)
    @following_users =
      current_user.active_relationships.between_times(Time.zone.now - 1.month, Time.zone.now)
    @followed_users =
      current_user.passive_relationships.between_times(Time.zone.now - 1.month, Time.zone.now)

    micropost_csv = ExportCsvService.new(@microposts, Micropost::CSV_ATTRIBUTES, "microposts.csv")
    following_csv =
      ExportCsvService.new(
        @following_users,
        Relationship::CSV_ATTRIBUTES,
        "following_users.csv",
        :followed
      )
    followed_csv =
      ExportCsvService.new(
        @followed_users,
        Relationship::CSV_ATTRIBUTES,
        "follower_users.csv",
        :follower
      )
    respond_to do |format|
      format.html
      format.zip do
        send_data ZipService.zip(micropost_csv, following_csv, followed_csv),
                  filename: "activity_log.zip"
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

  def edit; end

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

  def chat
    @microposts = @user.microposts.paginate(page: params[:page])
    @room_name = get_name(@user, current_user)
    @single_room =
      Room.where(name: @room_name).first ||
        Room.create_private_room([@user, @current_user], @room_name)
    @messages = @single_room.messages

    render "users/show"
  end

  private

  def get_name user1, user2
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_current_user
    @current_user = current_user
  end
end
