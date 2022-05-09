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

def positional(p1, p2)
    puts p1
    puts p2
end

positional(1, 2)

def keyword(p1:, p2:)
    puts p1
    puts p2
end

keyword(p1: 3, p2: 4)
keyword(p2: 5, p1: 6)
keyword(:p2 => 7, :p1 => 8)
