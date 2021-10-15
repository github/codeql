require "shellwords"
require "open3"

class UsersController < ActionController::Base
    def create
        cmd = params[:cmd]
        `#{cmd}`
        system(cmd)
        system("echo", cmd) # OK, because cmd is not shell interpreted
        exec(cmd)
        %x(echo #{cmd})
        result = <<`EOF`
        #{cmd}
EOF

        safe_cmd_1 = Shellwords.escape(cmd)
        `echo #{safe_cmd_1}`

        safe_cmd_2 = Shellwords.shellescape(cmd)
        `echo #{safe_cmd_2}`

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
        Open3.pipeline(["echo", cmd], "tail") # OK, because cmd is not shell interpreted
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
