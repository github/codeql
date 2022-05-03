class UsersController < ActionController::Base
    def index
        # GOOD: the host of `params[:url]` can not be controlled by an attacker
        if params[:url].match? /\Ahttps?:\/\/www\.example\.com\//
            redirect_to params[:url]
        end
    end
end