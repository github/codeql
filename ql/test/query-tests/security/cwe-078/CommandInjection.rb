class UsersController < ActionController::Base
    def create
        cmd = params[:cmd]
        `#{cmd}`
        system(cmd)
        exec(cmd)
        %x(#{cmd})
    end

    def show
        `ls`
        system("ls")
        exec("ls")
        %x(ls)
    end
end