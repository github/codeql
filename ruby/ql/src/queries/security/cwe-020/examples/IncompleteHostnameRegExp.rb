class AppController < ApplicationController

    def index
        url = params[:url]
        host = URI(url).host
        # BAD: the host of `url` may be controlled by an attacker
        regex = /^((www|beta).)?example.com/
        if host.match(regex)
            redirect_to url
        end
    end

end
