class MicropostsController < ApplicationController
  load_and_authorize_resource

  def create
    if @micropost.save
      flash[:success] = "Create micropost successfully"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted!"
    redirect_to request.referer || root_url
  end

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end
end
