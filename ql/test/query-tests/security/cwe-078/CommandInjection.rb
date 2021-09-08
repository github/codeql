require "shellwords"
require "open3"

class UsersController < ActionController::Base
    def create
        cmd = params[:cmd]
        `#{cmd}`
        system(cmd)
        exec(cmd)
        %x(echo #{cmd})
        result = <<`EOF`
        #{cmd}
EOF

        safe_cmd = Shellwords.escape(cmd)
        `echo #{safe_cmd}`

        if cmd == "some constant"
            `echo #{cmd}`
        end

        if %w(foo bar).include? cmd
            `echo #{cmd}`
        else
            `echo #{cmd}`
        end

        # Open3 methods
        Open3.capture2("echo #{cmd}")
        Open3.pipeline("cat foo.txt", "grep #{cmd}")
    end

    def show
        `ls`
        system("ls")
        exec("ls")
        %x(ls)
    end

    def index
        cmd = params[:key]
        if %w(foo bar).include? cmd
            `echo #{cmd}`
        end
        Open3.capture2("echo #{cmd}")
    end
end
