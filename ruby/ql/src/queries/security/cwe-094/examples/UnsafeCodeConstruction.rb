module MyLib
    def unsafeDeserialize(value)
        eval("foo = #{value}")
        foo
    end

    def unsafeGetter(obj, path)
        eval("obj.#{path}")
    end
end
