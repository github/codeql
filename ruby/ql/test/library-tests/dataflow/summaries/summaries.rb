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
args = { foo: source("tainted") }
sink(Foo.namedArg(**args)) # $ hasTaintFlow=tainted

sink(Foo.anyArg(foo: tainted)) # $ hasTaintFlow=tainted
sink(Foo.anyArg(tainted)) # $ hasTaintFlow=tainted

sink(Foo.anyNamedArg(foo: tainted)) # $ hasTaintFlow=tainted
sink(Foo.anyNamedArg(tainted))

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

a = ["elem0", source("elem1"), source("elem2")]
sink(a[0])
sink(a[1]) # $ hasValueFlow=elem1
sink(a[2]) # $ hasValueFlow=elem2
b = a.withElementOne()
sink(b[0])
sink(b[1]) # $ hasValueFlow=elem1
sink(b[2])
a.withoutElementOne()
sink(a[0])
sink(a[1])
sink(a[2]) # $ hasValueFlow=elem2

x = Foo.new
x.set_value(source("attr"))
sink(x.get_value) # $ hasValueFlow=attr

x = Foo.new
y = []
z = []
# This just highlights that none of x,y,z was tainted before
sink(x)
sink(y)
sink(z)

x.flowToAnyArg(tainted, y, key: z)
sink(x)
sink(y) # $ hasTaintFlow=tainted
sink(z) # $ hasTaintFlow=tainted

x = Foo.new
x.flowToSelf(tainted)
sink(x) # $ hasTaintFlow=tainted

Foo.sinkAnyArg(tainted) # $ hasValueFlow=tainted
Foo.sinkAnyArg(key: tainted) # $ hasValueFlow=tainted

Foo.sinkAnyNamedArg(tainted)
Foo.sinkAnyNamedArg(key: tainted) # $ hasValueFlow=tainted
