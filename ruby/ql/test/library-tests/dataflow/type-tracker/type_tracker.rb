class Container
    def field=(val)
        puts self.field
        @field = val
    end

    def field
        @field
    end
end

def m()
    var = Container.new
    var.field = "hello"
    puts var.field
end

def foo(a, *b, c)
    puts a
    puts b
    puts c
end

foo('a', 'b1', 'b2', 'c')
