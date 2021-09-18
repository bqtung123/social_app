class PasswordResetsController < ApplicationController
    before_action :get_user, only: [:edit,:update]
    before_action :valid_user,only: [:edit,:update]
    before_action :check_expiration, only: [:edit,:update]
    
    def get_user
        @user= User.find_by(email: params[:email])
    end

    def valid_user
       unless @user && @user.activated? && @user.authenticated?(:reset,params[:id])
           flash[:danger]="account invalid"
           redirect_to root_url
       end
    end

    def new

    end

    def create
          @user = User.find_by(email: params[:password_reset][:email])
          if @user
              @user.create_reset_digest
              @user.send_password_reset_email
              flash[:success]="Password reset email sent!"
              redirect_to root_url
          else
              flash.now[:danger]= "Email not exist"
              render 'new'
          end
    end

    def edit

    end


    def update
        if params[:user][:password].empty?
            @user.errors.add(:password,"Password must not empty")
            render 'edit'
        elsif @user.update(user_params)
            
            flash[:success] = "Password reset successfull"
            login @user
            redirect_to @user
        else
            flash[:danger]="Invalid information"
            render 'edit'
        end
         
    end

    def check_expiration
           if @user.reset_expired?
               flash[:danger] = "Password reset has expired."
              redirect_to new_password_reset_url
           end
    end

    def user_params
         params.require(:user).permit(:password,:password_confirmation)
    end
end
