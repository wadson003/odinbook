class LikesController < ApplicationController
   before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(user: current_user)

    if @like.save
    redirect_back fallback_location: root_path, notice: "vous aimez cette publication."
    else
    redirect_back fallback_location: root_path, alert: "Impossible de liker"
    end
  end
  def destroy
     @like = current_user.likes.find(params[:id])
     @like.destroy
     redirect_back fallback_location: root_path, notice: "Mention J'aime retiree."
  end
end
