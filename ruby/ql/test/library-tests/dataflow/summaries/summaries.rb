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

notTainted = Foo.firstArg(nil, tainted)
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
d = a
a[rand()] = source("elem3")
sink(a.readElementOne(1)) # $ hasValueFlow=elem1 $ hasValueFlow=elem3
sink(a.readExactlyElementOne(1)) # $ hasValueFlow=elem1
sink(a[0]) # $ hasValueFlow=elem3
sink(a[1]) # $ hasValueFlow=elem1 $ hasValueFlow=elem3
sink(a[2]) # $ hasValueFlow=elem2 $ hasValueFlow=elem3
b = a.withElementOne()
sink(b[0]) # $ hasValueFlow=elem3
sink(b[1]) # $ hasValueFlow=elem1 $ hasValueFlow=elem3
sink(b[2]) # $ hasValueFlow=elem3
c = a.withExactlyElementOne()
sink(c[0])
sink(c[1]) # $ hasValueFlow=elem1
sink(c[2])
a.withoutExactlyElementOne()
sink(a[0]) # $ hasValueFlow=elem3
sink(a[1]) # $ hasValueFlow=elem3
sink(a[2]) # $ hasValueFlow=elem2 $ hasValueFlow=elem3
a.withoutElementOne()
sink(a[0])
sink(a[1])
sink(a[2]) # $ hasValueFlow=elem2
d[3] = source("elem3")
d.withoutElementOneAndTwo()
sink(d[0])
sink(d[1])
sink(d[2])
sink(d[3]) # $ hasValueFlow=elem3

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

Foo.sinkAnyArg(tainted) # $ hasValueFlow=tainted $ hasTaintFlow=tainted
Foo.sinkAnyArg(key: tainted) # $ hasValueFlow=tainted

Foo.sinkAnyNamedArg(tainted)
Foo.sinkAnyNamedArg(key: tainted) # $ hasValueFlow=tainted

"magic_string".method(tainted) # $ hasValueFlow=tainted
"magic_string2".method(tainted)

Alias::Foo.method(tainted) # $ hasValueFlow=tainted
Alias::Bar.method(tainted) # $ hasValueFlow=tainted
Something::Foo.method(tainted)
Alias::Something.method(tainted)

Foo.getSinks()[0].mySink(tainted) # $ hasValueFlow=tainted
Foo.arraySink(tainted)
Foo.arraySink([tainted]) # $ hasValueFlow=tainted

Foo.secondArrayElementIsSink([tainted, "safe", "safe"])
Foo.secondArrayElementIsSink(["safe", tainted, "safe"]) # $ hasValueFlow=tainted
Foo.secondArrayElementIsSink(["safe", "safe", tainted])
Foo.secondArrayElementIsSink([tainted] * 10) # $ MISSING: hasValueFlow=tainted

FuzzyLib.fuzzyCall(tainted) # $ hasValueFlow=tainted
FuzzyLib.foo.bar.fuzzyCall(tainted) # $ hasValueFlow=tainted
FuzzyLib.foo[0].fuzzyCall(tainted) # $ hasValueFlow=tainted
FuzzyLib.foo do |x|
  x.fuzzyCall(tainted) # $ hasValueFlow=tainted
  x.otherCall(tainted)
end
class FuzzySub < FuzzyLib::Foo
  def blah
    self.fuzzyCall(source("tainted")) # $ hasValueFlow=tainted
  end
  def self.blah
    self.fuzzyCall(source("tainted")) # $ hasValueFlow=tainted
  end
end
