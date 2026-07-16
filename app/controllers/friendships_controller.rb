class FriendshipController < ApplicationController
  def create
    @friendship = current_user.sent_friendships.build(receiver_id: params(:receiver_id), status: "pending")
    if @friendship.save
      flash[:notice] = "Demande de suivi envoyee !"
    else
      flash[:alert] = "Impossible d'envoyer la demande."
    end
    redirect_back fallback_location: users_path
  end
  def update
    @friendship = Friendship.find(params[:id])
    if @friendship.receiver == current_user && @friendship.update(status: "accepted")
      flash[:notice] = "Demande acceptee"
    else
      flash[:alert] = "Action impossible."
    end
    redirect_back fallback_location: root_path
  end
end
