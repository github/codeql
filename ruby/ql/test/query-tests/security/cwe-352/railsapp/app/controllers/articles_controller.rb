class ArticlesController < ApplicationController
  prepend_before_action :user_authored_article?, only: [:delete_authored_article]

  def delete_authored_article
    article.destroy
  end

  def article
    @article ||= Article.find(params[:article_id])
  end

  def user_authored_article?
    @article.author_id = current_user.id
  end
end
