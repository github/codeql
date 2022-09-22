def foo
    puts "foo"
end

foo

def self.bar
    puts "bar1"
end

self.bar

def self.bar
    puts "bar2"
end

self.bar

self.foo

module M
    def instance_m
        singleton_m # NoMethodError
    end
    def self.singleton_m
        instance_m # NoMethodError
    end

    instance_m # NoMethodError
    self.instance_m # NoMethodError
    
    singleton_m
    self.singleton_m
end

M.instance_m # NoMethodError
M.singleton_m

def call_instance_m
    instance_m # NoMethodError
end

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
    alias :old_puts :puts
    def puts x; old_puts x end
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
    alias :old_lookup :[]
    def [] x; old_lookup(x) end
end

class Array
  alias :old_lookup :[]
  def [] x; old_lookup(x) end

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

class Singletons
    def self.singleton_a
        puts "singleton_a"
        self.singleton_b
    end
    
    def self.singleton_b
        puts "singleton_b"
        self.singleton_c
    end
    
    def self.singleton_c
        puts "singleton_c"
    end
    
    def self.singleton_d
        puts "singleton_d"
        self.singleton_a
    end

    def instance
        def self.singleton_e
            puts "singleton_e"
        end
        singleton_e
    end

    class << self
        def singleton_f
            puts "singleton_f"
        end
    end

    def call_singleton_g
        self.singleton_g
    end
end
  
Singletons.singleton_a
Singletons.singleton_f

c1 = Singletons.new

c1.instance
c1.singleton_e

def c1.singleton_g;
    puts "singleton_g_1"
end

c1.singleton_g
c1.call_singleton_g

def c1.singleton_g;
    puts "singleton_g_2"
end

c1.singleton_g
c1.call_singleton_g

class << c1
    def singleton_g;
        puts "singleton_g_3"
    end
end

c1.singleton_g
c1.call_singleton_g

c2 = Singletons.new
c2.singleton_e # NoMethodError
c2.singleton_g # NoMethodError

self.new # NoMethodError

puts "top-level"

def Singletons.singleton_g
    puts "singleton_g"
end

Singletons.singleton_g
c1.singleton_g
c1.call_singleton_g
c2.singleton_g # NoMethodError
c3 = Singletons.new
c3.singleton_g # NoMethodError

def create(type)
    type.new.instance

    def type.singleton_h
        puts "singleton_h"
    end

    type.singleton_h
end

create Singletons
Singletons.singleton_h

x = Singletons

class << x
    def singleton_i
        puts "singleton_i"
    end
end

x.singleton_i
Singletons.singleton_i

class << Singletons
    def singleton_j
        puts "singleton_j"
    end
end

Singletons.singleton_j

class SelfNew
    def instance
        puts "SelfNew#instance"
        new.instance # NoMethodError
    end

    def self.singleton
        new.instance
    end

    new.instance
end

SelfNew.singleton

class C1
    def instance
        puts "C1#instance"
    end
end

class C2 < C1
    def instance
        puts "C2#instance"
    end
end

class C3 < C2
    def instance
        puts "C3#instance"
    end
end

def pattern_dispatch x
    case x
    when C3
        x.instance
    when C2
        x.instance
    when C1
        x.instance
    else
    end

    case x
        in C3 then x.instance
        in C2 => c2 then c2.instance
        in C1 => c1 then c1.instance
    end
end

c1 = C1.new
c1.instance
pattern_dispatch (C1.new)
pattern_dispatch (C2.new)
pattern_dispatch (C3.new)

def add_singleton x
    def x.instance
        puts "instance_on x"
    end
end

c3 = C1.new
add_singleton c3
c3.instance

class SingletonOverride1
    class << self
        def singleton1
            puts "SingletonOverride1#singleton1"
        end

        def call_singleton1
            singleton1
        end
    end

    def self.singleton2
        puts "SingletonOverride1#singleton2"
    end

    def self.call_singleton2
        singleton2
    end

    singleton2
end

SingletonOverride1.call_singleton1
SingletonOverride1.call_singleton2

class SingletonOverride2 < SingletonOverride1
    class << self
        def singleton1
            puts "SingletonOverride2#singleton1"
        end
    end

    def self.singleton2
        puts "SingletonOverride2#singleton2"
    end
end

SingletonOverride2.call_singleton1
SingletonOverride2.call_singleton2
