module EnglishWords
    def hello
        return "hello"
    end
    def world
        return "world"
    end
end


class Greeting
    include EnglishWords
    def message 
        return hello
    end
end

class HelloWorld < Greeting
    def message
        return super + " " + world + "!"
    end
end