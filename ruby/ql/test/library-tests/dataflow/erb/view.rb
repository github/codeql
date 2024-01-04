class View
    def initialize(x)
        @x = x
    end

    def foo
        sink(@x) # $ hasValueFlow=1
    end
end