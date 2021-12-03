def sink s
    puts s
end

sink "taint"

def yielder x
    yield x
end

yielder "no taint" { |x| sink x } # no flow

yielder "taint" { |x| puts x } # no flow

yielder "taint" { |x| sink x } # flow

def apply_lambda (lambda, x)
    lambda.call(x)
end

my_lambda = -> (x) { sink x }
apply_lambda(my_lambda, "no taint") # no flow

my_lambda = -> (x) { puts x }
apply_lambda(my_lambda, "taint") # no flow

my_lambda = -> (x) { sink x }
apply_lambda(my_lambda, "taint") # flow

my_lambda = lambda { |x| sink x }
apply_lambda(my_lambda, "no taint") # no flow

my_lambda = lambda { |x| puts x }
apply_lambda(my_lambda, "taint") # no flow

my_lambda = lambda { |x| sink x }
apply_lambda(my_lambda, "taint") # flow

