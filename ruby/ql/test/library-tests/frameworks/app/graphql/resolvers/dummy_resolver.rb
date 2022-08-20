module Resolvers
  class DummyResolver < Resolvers::Base
    type String, null: false
    argument :something_id, ID, required: true

    def load_something(id)
      "Something number #{id}"
    end

    def resolve(something:)
      system("echo #{something}")
      "true"
    end
  end
end
