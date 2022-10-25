module A
    class B
        def self.ab_singleton_method # should not be called
        end
    end
end

do_something do
    def method_in_block
        ab_singleton_method # should not resolve to anything
    end
    obj=self
    def obj.method_in_block
        ab_singleton_method # should not resolve to anything
    end
end

MyStruct = Struct.new(:foo, :bar) {
    def self.method_in_struct
        ab_singleton_method # should not resolve to anything
    end
}

module Good
    class << self
        def call_me
        end

        def call_you
            call_me
            call_you
        end
    end
end
