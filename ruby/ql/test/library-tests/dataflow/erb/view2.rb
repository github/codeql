class View2 < ViewComponent::Base
    def foo
        sink(@x) # $ hasValueFlow=3
    end

    def set(x)
        @x = x
    end
end