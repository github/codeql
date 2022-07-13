class UsersController < ActionController::Base
    def index
        # BAD: the host of `params[:url]` may be controlled by an attacker
        if params[:url].match? /https?:\/\/www\.example\.com\//
            redirect_to params[:url]
        end
    end
end