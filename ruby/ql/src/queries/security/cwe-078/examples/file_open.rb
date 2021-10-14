class UsersController < ActionController::Base
    def create
      filename = params[:filename]
      File.open(filename)
    end
  end  