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

def throughArray(obj, y, z)
    tmp = [obj]
    tmp[0]

    array = [1,2,3,4,5,6]
    array[y] = obj
    array[0]

    array2 = [1,2,3,4,5,6]
    array2[0] = obj
    array2[y]

    array3 = [1,2,3,4,5,6]
    array3[0] = obj
    array3[1]

    array4 = [1,2,3,4,5,6]
    array4[y] = obj
    array4[z]
end
