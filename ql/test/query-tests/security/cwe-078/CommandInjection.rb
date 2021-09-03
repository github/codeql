require "shellwords"

class UsersController < ActionController::Base
    def create
        cmd = params[:cmd]
        `#{cmd}`
        system(cmd)
        exec(cmd)
        %x(echo #{cmd})
        safe_cmd = Shellwords.escape(cmd)
        `echo #{safe_cmd}`
    end

    def show
        `ls`
        system("ls")
        exec("ls")
        %x(ls)
    end
end