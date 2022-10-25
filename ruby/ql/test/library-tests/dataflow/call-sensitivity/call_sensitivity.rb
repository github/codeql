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
    sink x # $ hasValueFlow=10 $ hasValueFlow=11
  end

  def method2 x
    method1 x
  end

  def method3(x, y)
    x.method1(y)
  end
end

a = A.new
a.method2(taint 10)
a.method3(a, taint(11))

class B < A
  def method1 x
    puts x
  end
end

b = B.new
b.method2(taint 12)
b.method3(b, taint(13))
