class ClassWithElementRef
    def [](x)
        yield x + 1
    end
end

c = ClassWithElementRef.new

c[1] { |x| puts x }

c[1] do |x|
    puts x
end
