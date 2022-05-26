class AppController < ApplicationController
    def index
        url = params[:url]
        # BAD: the host of `url` may be controlled by an attacker
        if url.include?("example.com")
            redirect_to url
        end
    end
end