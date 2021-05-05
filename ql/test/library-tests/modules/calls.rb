def foo
    puts "foo"
end

foo

def self.bar
    puts "bar"
end

self.bar

self.foo

module M
    def instance_m; end
    def self.singleton_m; end

    instance_m # NoMethodError
    self.instance_m # NoMethodError
    
    singleton_m
    self.singleton_m
end

M.instance_m # NoMethodError
M.singleton_m

class C
    include M
    instance_m # NoMethodError
    self.instance_m # NoMethodError
    
    singleton_m # NoMethodError
    self.singleton_m # NoMethodError

    def baz 
        instance_m 
        self.instance_m 
        
        singleton_m # NoMethodError
        self.singleton_m # NoMethodError
    end
end 

c = C.new
c.baz
c.singleton_m # NoMethodError
c.instance_m

class D < C
    def baz
        super
    end
end

d = D.new
d.baz
d.singleton_m # NoMethodError
d.instance_m