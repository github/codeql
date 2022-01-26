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
  end
end
