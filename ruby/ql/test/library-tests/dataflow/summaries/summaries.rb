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
