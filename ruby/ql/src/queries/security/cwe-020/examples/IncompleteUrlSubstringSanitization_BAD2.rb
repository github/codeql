class AppController < ApplicationController
    def index
        url = params[:url]
        host = URI(url).host
        # BAD: the host of `url` may be controlled by an attacker
        if host.include?("example.com")
            redirect_to url
        end
    end
end
