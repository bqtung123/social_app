class AccountActivationsController < ApplicationController
    def edit
         @user =User.find_by(email: params[:email])
         if @user && @user.authenticated?(:activation,params[:id])
             @user.update_attribute(:activated,true)
             @user.update_attribute(:activated_at, Time.zone.now)
             flash[:success] = "Account activated successfully"
             login @user
             redirect_to @user
         else
             flash[:danger]="Invalid link"
             redirect_to root_url
         end
    end
end
