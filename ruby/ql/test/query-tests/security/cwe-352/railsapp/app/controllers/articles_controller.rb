class ArticlesController < ApplicationController
  prepend_before_action :user_authored_article?, only: [:delete_authored_article, :change_title]

  # GOOD: `with: :exception` provides more effective CSRF protection than
  # `with: :null_session` or `with: :reset_session`.
  protect_from_forgery with: :exception, only: [:change_title]

  def delete_authored_article
    article.destroy
  end

  def change_title
    article.title = params[:article_title]
    article.save!
  end

  def article
    @article ||= Article.find(params[:article_id])
  end

  def user_authored_article?
    @article.author_id = current_user.id
  end
end
