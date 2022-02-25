tainted = identity "taint"
sink tainted

tainted2 = apply_block tainted do |x|
  sink x
  x
end

sink tainted2

my_lambda = -> (x) {
  sink x
  x
}

tainted3 = apply_lambda(my_lambda, tainted)

sink(tainted3)

tainted4 = Foo.firstArg(tainted)
sink(tainted4)

notTainted = Foo.firstArg(nil, tainted))
sink(notTainted)

tainted5 = Foo.secondArg(nil, tainted)
sink(tainted5)
