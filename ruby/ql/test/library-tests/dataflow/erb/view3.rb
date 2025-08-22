class View3 < ViewComponent::Base
    def initialize(x)
        @x = x
    end

    def get
        @x
    end
end