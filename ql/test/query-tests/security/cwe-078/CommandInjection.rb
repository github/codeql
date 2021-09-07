require "shellwords"

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
        end
    end

    def show
        `ls`
        system("ls")
        exec("ls")
        %x(ls)
    end
end
