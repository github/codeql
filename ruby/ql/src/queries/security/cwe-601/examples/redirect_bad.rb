class HelloController < ActionController::Base
  def hello
    redirect_to params[:url]
  end
end
