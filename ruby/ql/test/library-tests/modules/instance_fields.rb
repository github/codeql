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
        def return
            @field
        end
    end
end
class B_target
    def target
    end
end

class C
    class << self
        def set value
            @field = value
        end
        def get
            @field
        end
    end
end
class C_target
    def target
    end
end

C.set ::C_target.new
C.get.target