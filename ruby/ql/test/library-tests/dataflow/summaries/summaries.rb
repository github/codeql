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

sink(Foo.onlyWithBlock(tainted))
sink(Foo.onlyWithBlock(tainted) do |x| end)
sink(Foo.onlyWithoutBlock(tainted))
sink(Foo.onlyWithoutBlock(tainted) do |x| end)

Foo.new.method(tainted)
Bar.new.method(tainted)
Bar.new.next.method(tainted)
Bar.new.next.next.next.next.method(tainted)

def userDefinedFunction(x, y)
  t = "taint"
  sink(x.matchedByName(t))
  sink(y.matchedByName(t))
  sink(x.unmatchedName(t))
  sink(t.matchedByNameRcv())
end

Foo.blockArg do |x|
  sink(x.preserveTaint("taint"))
end
