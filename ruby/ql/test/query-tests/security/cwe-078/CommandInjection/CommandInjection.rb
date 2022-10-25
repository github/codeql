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

module Types
  class BaseObject < GraphQL::Schema::Object; end
  class QueryType < BaseObject
    field :test_field, String, null: false,
      description: "An example field added by the generator",
      resolver: Resolvers::DummyResolver

    field :with_arg, String, null: false, description: "A field with an argument" do
      argument :number, Int, "A number", required: true
    end
    def with_arg(number:)
      system("echo #{number}")
      number.to_s
    end

    field :with_method, String, null: false, description: "A field with a custom resolver method", resolver_method: :custom_method do
      argument :blah_number, Int, "A number", required: true
    end
    def custom_method(blah_number:, number: nil)
      system("echo #{blah_number}")
      system("echo #{number}") # OK, number: is not an `argument` for this field
      blah_number.to_s
    end

    field :with_splat, String, null: false, description: "A field with a double-splatted argument" do
      argument :something, Int, "A number", required: true
    end
    def with_splat(**args)
      system("echo #{args[:something]}")
      args[:something].to_s
    end

    def foo(arg)
      system("echo #{arg}") # OK, this is just a random method, not a resolver method
    end
  end
end
