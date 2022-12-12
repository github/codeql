class PostsController < ApplicationController
  before_action :set_user
  append_before_action :set_post, only: [:show, :upvote]
  after_action :log_upvote, only: :upvote

  def index
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
