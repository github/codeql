module Types
  class QueryType < Types::BaseObject
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
      system("echo #{number}")
      blah_number.to_s
    end

    field :with_splat, String, null: false, description: "A field with a double-splatted argument" do
      argument :something, Int, "A number", required: true
    end
    def with_splat(**args)
      system("echo #{args[:something]}")
      args[:something].to_s
    end

    field :with_splat_and_named_arg, String, null: false, description: "A field with two named arguments, where the method captures the second via a hash splat param" do
      argument :arg1, Int, "A number", required: true
      argument :arg2, Int, "Another number", required: true
    end
    def with_splat_and_named_arg(arg1:, **rest)
      system("echo #{arg1}")
      system("echo #{rest[:arg2]}")
      arg1.to_s
    end

    def foo(arg)
      system("echo #{arg}")
    end

    field :with_enum, String, null: false, description: "A field with an enum argument" do
      argument :enum, Types::MediaCategory, "An enum", required: true
      argument :arg2, String, "Another arg", required: true
    end
    def with_enum(**args)
      system("echo #{args[:enum]}")
      system("echo #{args[:arg2]}")
    end

    field :with_nested_enum, String, null: false, description: "A field with a nested enum argument" do
      argument :inner, Types::Post, "Post", required: true
    end
    def with_nested_enum(**args)
      system("echo #{args[:inner]}")
      system("echo #{args[:inner][:title]}")
      system("echo #{args[:inner][:media_category]}")
      system("echo #{args[:inner][:direction]}")
    end

    field :with_array, String do
      argument :list, [String], "Names"
    end
    def with_array(list:)
      system("echo #{list[0]}")
    end

    field :with_named_params, String do
      argument :arg1, String, "Arg 1"
      argument :arg2, Types::Post, "Arg 2"
      argument :arg3, Types::MediaCategory, "Arg 3"
    end
    def with_named_params(arg1:, arg2:, **args)
      system("echo #{arg1}")
      system("echo #{arg2}")
      system("echo #{arg2[:title]}")
      system("echo #{arg2[:media_category]}")
      system("echo #{args[:arg3]}")
      system("echo #{args[:not_an_arg]}")
    end
  end
end
