def taint x
    x
end

def sink x
    puts "SINK: #{x}"
end

sink (taint 1) # $ hasValueFlow=1

def yielder x
    yield x
end

yielder ("no taint") { |x| sink x }

yielder (taint 2) { |x| puts x }

yielder (taint 3) { |x| sink x } # $ hasValueFlow=3

def apply_lambda (lambda, x)
    lambda.call(x)
end

my_lambda = -> (x) { sink x }
apply_lambda(my_lambda, "no taint")

my_lambda = -> (x) { puts x }
apply_lambda(my_lambda, taint(4))

my_lambda = -> (x) { sink x } # $ hasValueFlow=5
apply_lambda(my_lambda, taint(5))

my_lambda = lambda { |x| sink x }
apply_lambda(my_lambda, "no taint")

my_lambda = lambda { |x| puts x }
apply_lambda(my_lambda, taint(6))

my_lambda = lambda { |x| sink x } # $ hasValueFlow=7
apply_lambda(my_lambda, taint(7))

MY_LAMBDA1 = lambda { |x| sink x } # $ hasValueFlow=8
apply_lambda(MY_LAMBDA1, taint(8))

MY_LAMBDA2 = lambda { |x| puts x }
apply_lambda(MY_LAMBDA2, taint(9))

class A
  def method1 x
    sink x # $ hasValueFlow=10 $ hasValueFlow=11 $ hasValueFlow=12 $ hasValueFlow=13 $ hasValueFlow=26 $ hasValueFlow=28 $ hasValueFlow=30 $ hasValueFlow=33 $ hasValueFlow=35 $ SPURIOUS: hasValueFlow=27
  end

  def method2 x
    method1 x
  end

  def call_method2 x
    self.method2 x
  end

  def method3(x, y)
    x.method1(y)
  end

  def call_method3 x
    self.method3(self, x)
  end

  def self.singleton_method1 x
    sink x # $ hasValueFlow=14 $ hasValueFlow=15 # $ hasValueFlow=16 $ hasValueFlow=17
  end

  def method4(x, y)
    [0, 1, 3].each do
      x.method1(y)
    end
  end

  def method5 x
    self.method1 x
  end

  def call_method5
    self.method5 (taint 33)
  end

  def self.singleton_method2 x
    singleton_method1 x
  end

  def self.call_singleton_method2 x
    self.singleton_method2 x
  end

  def self.singleton_method3(x, y)
    x.singleton_method1(y)
  end

  def self.call_singleton_method3 x
    self.singleton_method3(self, x)
  end

  def initialize(x)
    sink x # $ hasValueFlow=28 $ hasValueFlow=30 $ hasValueFlow=32 $ hasValueFlow=35
    method1 x
  end

  def self.call_new x
    new x
  end
end

a = A.new (taint 30)
a.method2(taint 10)
a.call_method2(taint 11)
a.method3(a, taint(12))
a.call_method3(taint(13))
a.method4(a, taint(26))

A.singleton_method2(taint 14)
A.call_singleton_method2(taint 15)
A.singleton_method3(A, taint(16))
A.call_singleton_method3(taint 17)
A.call_new(taint 35)

class B < A
  def method1 x
    puts "NON SINK: #{x}"
  end

  def self.singleton_method1 x
    puts "NON SINK: #{x}"
  end

  def call_method2 x
    self.method2 x
  end

  def call_method3 x
    self.method3(self, x)
  end

  def call_method5 x
    self.method5 (taint 34)
  end

  def self.call_singleton_method2 x
    self.singleton_method2 x
  end

  def self.call_singleton_method3 x
    self.singleton_method3(self, x)
  end

  def initialize(x)
    puts "NON SINK: #{x}"
  end
end

b = B.new (taint 31)
b.method2(taint 18)
b.call_method2(taint 19)
b.method3(b, taint(20))
b.call_method3(taint(21))
b.method4(b, taint(27))

B.singleton_method2(taint 22)
B.call_singleton_method2(taint 23)
B.singleton_method3(B, taint(24))
B.call_singleton_method3(taint 25)
B.call_new(taint 36)

def create (type, x)
  type.new x
end

create(A, taint(28))
create(B, taint(29))

class C < A
  def method1 x
    puts "NON SINK: #{x}"
  end
end

c = C.new (taint 32)

def invoke_block1 x
  yield x
end

def invoke_block2 x
  invoke_block1 x do |x|
    yield x
  end
end

invoke_block2 (taint 37) do |x|
  sink x # $ hasValueFlow=37
end

invoke_block2 "safe" do |x|
  sink x
end

def call_m (x, y)
  if x.respond_to? :m
    x.m y
  end
end

class D
  def m x
    sink x # $ hasValueFlow=38
  end
end

class E
end

call_m(D.new, (taint 38))
call_m(E.new, (taint 39))
