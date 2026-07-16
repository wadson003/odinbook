class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.author = current_user

    if @comment.save
      redirect_back fallback_location: root_path, notice: "commentaire ajoute !"
    else
      redirect_back fallback_location: root_path, alert: "Le commentaire ne peut pas etre vide."
    end
  end
  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end