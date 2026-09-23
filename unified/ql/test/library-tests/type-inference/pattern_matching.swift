func testSimplePattern(_ pair: (Int, String)) {
  let (number, text) = pair
  _ = number  // $ MISSING: type=number:Int
  _ = text  // $ MISSING: type=text:String
}

enum PatternMatch<T> {
  case novalue
  case value(T)
  case nested((T, (Int, String?)))
}

func testComplexPattern<T>(_ input: PatternMatch<T>) {
  switch input {
  case .novalue:
    break
  case .value(let value):
    _ = value  // $ MISSING: type=value:T
  case .nested((let value, (let count, let label?))):
    _ = value  // $ MISSING: type=value:T
    _ = count  // $ MISSING: type=count:Int
    _ = label  // $ MISSING: type=label:String
  case .nested((let value, (let count, nil))):
    _ = value  // $ MISSING: type=value:T
    _ = count  // $ MISSING: type=count:Int
  }
}

func createValue() -> PatternMatch<Bool> {
  var x = PatternMatch.value(42)  // $ type=x@PatternMatch<T>:Int target=PatternMatch.value
  var y = PatternMatch<String>.novalue  // $ type=y@PatternMatch<T>:String field=PatternMatch.novalue
  return PatternMatch.novalue  // $ type=.novalue@PatternMatch<T>:Bool field=PatternMatch.novalue
}
