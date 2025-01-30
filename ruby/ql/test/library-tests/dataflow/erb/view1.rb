class View1 < ViewComponent::Base
    def initialize(x)
        @x = x
    end

    def foo
        sink(@x) # $ hasValueFlow=1 $ hasValueFlow=2
    end

    def set(x)
        @x = x
    end
end
