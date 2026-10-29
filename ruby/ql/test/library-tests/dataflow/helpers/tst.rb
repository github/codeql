module C1
    def c1
        @field = 1
        @field
    end
end

class C2 < C1
    def c2
    end
end

module Mixin
    def m1
    end
    def self.m1s
    end
end

module Mixin2
    def m2
    end
    def self.m2s
    end
end

class C3 < C2
    include Mixin
    prepend Mixin2

    class << self
        def c3_self1
        end
    end
end

def C3.c3_self2
end

module N1
    class XY1 < X::Y
    end
    module N2
        class XY2 < X::Y
        end
    end
end

module N2
    include X
end
module N2
    class XY3 < Y
    end
end

class Nodes
    def m1
        array=[1,2,3]
        hash={'foo' => 1, 'bar' => 2, baz: 3}
    end
end
