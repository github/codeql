class UsersController < ActionController::Base
  def create
    filename = params[:filename]
    File.open(filename)

    web_page = params[:web_page]
    Net::HTTP.get(URI.parse(web_page))
  end
end
