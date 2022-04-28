tainted = identity source("tainted")
sink tainted # $ hasValueFlow=tainted

tainted2 = apply_block tainted do |x|
  sink x # $ hasValueFlow=tainted
  x
end

sink tainted2 # $ hasValueFlow=tainted

my_lambda = -> (x) {
  sink x # $ hasValueFlow=tainted
  x
}

tainted3 = apply_lambda(my_lambda, tainted)

sink(tainted3) # $ hasValueFlow=tainted

tainted4 = Foo.firstArg(tainted)
sink(tainted4) # $ hasTaintFlow=tainted

notTainted = Foo.firstArg(nil, tainted))
sink(notTainted)

tainted5 = Foo.secondArg(nil, tainted)
sink(tainted5) # $ hasTaintFlow=tainted

sink(Foo.onlyWithBlock(tainted))
sink(Foo.onlyWithBlock(tainted) do |x| end) # $ hasTaintFlow=tainted
sink(Foo.onlyWithoutBlock(tainted)) # $ hasTaintFlow=tainted
sink(Foo.onlyWithoutBlock(tainted) do |x| end)

Foo.new.method(tainted) # $ hasValueFlow=tainted
Bar.new.method(tainted) # $ hasValueFlow=tainted
Bar.new.next.method(tainted) # $ hasValueFlow=tainted
Bar.new.next.next.next.next.method(tainted) # $ hasValueFlow=tainted

def userDefinedFunction(x, y)
  t = source("t")
  sink(x.matchedByName(t)) # $ hasTaintFlow=t
  sink(y.matchedByName(t)) # $ hasTaintFlow=t
  sink(x.unmatchedName(t))
  sink(t.matchedByNameRcv()) # $ hasTaintFlow=t
end

Foo.blockArg do |x|
  sink(x.preserveTaint(source("blockArg"))) # $ hasTaintFlow=blockArg
end

sink(Foo.namedArg(foo: tainted)) # $ hasTaintFlow=tainted
sink(Foo.namedArg(tainted))

sink(Foo.anyArg(foo: tainted)) # $ hasTaintFlow=tainted
sink(Foo.anyArg(tainted)) # $ hasTaintFlow=tainted

sink(Foo.anyPositionFromOne(tainted))
sink(Foo.anyPositionFromOne(0, tainted)) # $ hasTaintFlow=tainted

Foo.intoNamedCallback(tainted, foo: ->(x) {
  sink(x) # $ hasTaintFlow=tainted
})
Foo.intoNamedParameter(tainted, ->(foo:) {
  sink(foo) # $ MISSING: hasTaintFlow=tainted
})

Foo.startInNamedCallback(foo: ->(x) {
  sink(x.preserveTaint(source("startInNamedCallback"))) # $ hasTaintFlow=startInNamedCallback
})
Foo.startInNamedParameter(->(foo:) {
  sink(foo.preserveTaint(source("startInNamedParameter"))) # $ hasTaintFlow=startInNamedParameter
})
