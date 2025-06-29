require "shellwords"
require "open3"

class UsersController < ActionController::Base
    def create
        cmd = params[:cmd] # $ Source
        `#{cmd}` # $ Alert
        system(cmd) # $ Alert
        system("echo", cmd) # OK, because cmd is not shell interpreted
        exec(cmd) # $ Alert
        %x(echo #{cmd}) # $ Alert
        result = <<`EOF`
        #{cmd} #{# $ Alert
                }
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
            `echo #{cmd}` # $ Alert
        end

        # Open3 methods
        Open3.capture2("echo #{cmd}") # $ Alert
        Open3.pipeline("cat foo.txt", "grep #{cmd}") # $ Alert
        Open3.pipeline(["echo", cmd], "tail") # OK, because cmd is not shell interpreted
    end

    def show
        `ls`
        system("ls")
        exec("ls")
        %x(ls)
    end

    def index
        cmd = params[:key] # $ Source
        if %w(foo bar).include? cmd
            `echo #{cmd}`
        end
        Open3.capture2("echo #{cmd}") # $ Alert
    end

    def update
      cmd = params[:key] # $ Source
      case cmd
      when "foo"
        system(cmd)
      end
      system(cmd) # $ Alert
    end
end

module Types
  class BaseObject < GraphQL::Schema::Object; end
  class QueryType < BaseObject
    field :test_field, String, null: false,
      description: "An example field added by the generator",
      resolver: Resolvers::DummyResolver

    field :with_arg, String, null: false, description: "A field with an argument" do
      argument :number, Int, "A number", required: true
    end
    def with_arg(number:) # $ Source
      system("echo #{number}") # $ Alert
      number.to_s
    end

    field :with_method, String, null: false, description: "A field with a custom resolver method", resolver_method: :custom_method do
      argument :blah_number, Int, "A number", required: true
    end
    def custom_method(blah_number:, number: nil) # $ Source
      system("echo #{blah_number}") # $ Alert
      system("echo #{number}") # OK, number: is not an `argument` for this field
      blah_number.to_s
    end

    field :with_splat, String, null: false, description: "A field with a double-splatted argument" do
      argument :something, Int, "A number", required: true
    end
    def with_splat(**args)
      system("echo #{args[:something]}") # $ Alert
      args[:something].to_s
    end

    def foo(arg)
      system("echo #{arg}") # OK, this is just a random method, not a resolver method
    end
  end
end

class Foo < ActionController::Base
    def create
        file = params[:file] # $ Source
        system("cat #{file}") # $ Alert
        # .shellescape
        system("cat #{file.shellescape}") # OK, because file is shell escaped

    end

    def index
      Terrapin::CommandLine.new(params[:foo], "bar") # $ Alert

      Terrapin::CommandLine.new("echo", "#{params[foo]}") # $ Alert

      cmd = Terrapin::CommandLine.new("echo", ":msg")
      cmd.run(msg: params[:foo]) # GOOD
    end
end
