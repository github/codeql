class PostsController < ApplicationController
  before_action :set_user
  append_before_action :set_post, only: [:show, :upvote]
  after_action :log_upvote

  # these calls override the earlier ones
  after_action :log_upvote, only: :upvote
  before_action :set_user
  skip_before_action :set_user
  before_action :set_user

  def index
    PostsController.render(template: "posts/index")
    PostsController.renderer.render(template: "posts/index", locals: { show_full_post: true }, assigns: { @posts => Post.all })
  end

  def show
  end
  
  def upvote
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def log_upvote
    Rails.logger.info("Post upvoted: #{@post.id}")
  end
end

class NotAController
  def foo
    PostsController.render(template: "posts/index")
  end
end

