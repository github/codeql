class A
    class << self
        def create
            @field = ::A_target.new
        end
        def use
            @field.target
        end
    end
end
class A_target
    def target
    end
end

class B
    class << self
        def create
            @field = ::B_target.new
        end
        def use
            @field.target
        end
    end
end
class B_target
    def target
    end
end
