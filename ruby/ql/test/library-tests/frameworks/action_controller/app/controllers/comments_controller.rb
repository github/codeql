class CommentsController < ApplicationController
  after_action :check_feature_flags
  after_action :log_comment_change
  prepend_after_action :this_must_run_last
  before_action :set_user
  before_action :ensure_user_can_edit_comments, only: WRITE_ACTIONS
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :foo, :bar

  # this overrides the earlier callback on L3
  after_action :log_comment_change, except: READ_ACTIONS
  prepend_before_action :this_must_run_first

  WRITE_ACTIONS = %i[create update destroy]
  READ_ACTIONS = %i[index show new]

  def index
    request.params
    request.parameters
    request.GET
    request.POST
    request.query_parameters
    request.request_parameters
    request.filtered_parameters

    response.body = "some content"

    response.status = 200

    response.header["Content-Type"] = "text/html"
    response.set_header("Content-Length", 100)
    response.headers["X-Custom-Header"] = "hi"
    response["X-Another-Custom-Header"] = "yes"
    response.add_header "X-Yet-Another", "indeed"

    response.send_file("my-file.ext")

    response.request

    response.location = "http://..." # relevant for url redirect query
    response.cache_control = "value"
    response._cache_control = "value"
    response.etag = "value"
    response.charset = "value" # sets the charset part of the content-type header
    response.content_type = "value" # sets the main part of the content-type header

    response.date = Date.today
    response.last_modified = Date.yesterday
    response.weak_etag = "value"
    response.strong_etag = "value"
  end

  def create
  end

  def show
    respond_to do |format|
      format.html { redirect_to(comment_view_url) }
      format.json
      format.xml  { render xml: @comment.to_xml(include: @photo) }
    end
  end

  def photo
    send_data @photo
  end

  def destroy
    body = request.body_stream
  end

  private

  def ensure_user_can_edit_comments
    return if @user.can_edit_comments?
    render status: 403, text: "You are not allowed to edit comments"
  end

  def set_comment
    @comment = @user.comments.find(params[:id])
  end

  def log_comment_change
    AuditLog.create!(:comment_change, user: @user, comment: @comment)
  end
  
  def check_feature_flags
    raise CommentsNotEnabled unless FeatureFlag.enabled?(:comments)
  end

  def this_must_run_first
    # for whatever reason
  end

  def this_must_run_last
    # for whatever reason
  end

  def foo
  end

  def bar
  end
end
