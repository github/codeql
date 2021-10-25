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

def optional_arg(a = 4, b: 5)
    a.bit_length
    b.bit_length
end

def call_block
    yield 1
end

def foo()
    var = Hash.new
    var[1]
    call_block { |x| var[x] }
end

class Integer
    def bit_length; end
    def abs; end
end

class String
    def capitalize; end
end

module Kernel
    def puts; end
end

class Module
    def module_eval; end
    def include; end
    def prepend; end
    def private; end
end

class Object < Module
    include Kernel
    def new; end
end

class Hash
    def []; end
end

class Array
  def []; end
  def length; end

  def foreach &body
    x = 0
    while x < self.length
        yield x, self[x]
        x += 1
    end
  end
end

def funny
    yield "prefix: "
end

funny { |i| puts i.capitalize}

"a".capitalize
1.bit_length
1.abs

["a","b","c"].foreach { |i, v| puts "#{i} -> #{v.capitalize}"} # TODO should resolve to String.capitalize

[1,2,3].foreach { |i| i.bit_length}

[1,2,3].foreach { |i| puts i.capitalize} # NoMethodError

[1,-2,3].foreach { |_, v| puts v.abs} # TODO should resolve to Integer.abs

def indirect &b
    call_block &b
end

indirect { |i| i.bit_length}


class S
    def s_method
        self.to_s
    end
end

class A < S
    def to_s
    end
end

class B < S
    def to_s
    end
end

S.new.s_method
A.new.s_method
B.new.s_method

def private_on_main
end

private_on_main
