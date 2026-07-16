class PostsController < ApplicationController
  # Force la connexion pour toutes les actions de ce contrôleur
  before_action :authenticate_user!

  def index
    # 1. Récupération sécurisée des publications du fil d'actualité
    friend_ids = current_user.friends.pluck(:id)
    author_ids = friend_ids + [ current_user.id ]
    @posts = Post.where(author_id: author_ids).includes(:author, :comments, :likes).order(created_at: :desc)

    # 2. L'instance indispensable pour le formulaire form_with
    @post = Post.new
    @posts = Post.all.order(created_at: :desc).includes(:author, :comments, :likes)
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Publication créée avec succès !"
    else
      # Si la sauvegarde échoue (ex: texte vide), on DOIT recharger @posts pour la vue :
      friend_ids = current_user.friends.pluck(:id)
      author_ids = friend_ids + [ current_user.id ]
      @posts = Post.where(author_id: author_ids).includes(:author, :comments, :likes).order(created_at: :desc)

      # Sécurité : On s'assure que @post n'est pas nil pour le rendu
      @post ||= Post.new
      render :index, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
