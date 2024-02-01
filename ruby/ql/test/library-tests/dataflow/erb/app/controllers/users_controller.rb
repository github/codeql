class UsersController < ActionController::Base
    def index
        @x = source("index")
        render
    end

    def show
        @x = source("show")
        # implicit call to `render`
    end

    def edit
        @x = source("edit")
        render
    end
end
