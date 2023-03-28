class CommentsController < ApplicationController
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

  def show
  end
end
