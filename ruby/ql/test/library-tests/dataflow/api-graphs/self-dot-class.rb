module SelfDotClass
    module Mixin
        def foo
            self.class.bar # $ call=Member[Foo].Method[bar]
        end
    end
    class Subclass < Foo
        include Mixin
    end
end
