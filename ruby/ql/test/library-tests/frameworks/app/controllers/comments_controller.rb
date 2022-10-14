class CommentsController < ApplicationController
  def index
    request.params
    request.parameters
    request.GET
    request.POST
    request.query_parameters
    request.request_parameters
    request.filtered_parameters
  end

  def show
  end
end
