module Mutations
  class Dummy < BaseMutation
    argument :something_id, ID, required: false

    def load_something(id)
      "Something number #{id}"
    end

    def resolve(something:)
      system("echo #{something}")
      { success: true }
    end
  end
end
