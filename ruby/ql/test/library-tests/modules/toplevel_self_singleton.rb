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
end
