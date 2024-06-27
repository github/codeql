# This component has no corresponding template file, because it defines a `call` method instead.

class View4 < ViewComponent::Base
    def initialize(x)
        @x = x
    end

    def get
        @x
    end

    def call
        "hi"
    end
end