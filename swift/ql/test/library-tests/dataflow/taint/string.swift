func source() -> Int { return 0; }
func sink(arg: String) {}

func taintThroughInterpolatedStrings() {
  var x = source()
  
  sink(arg: "\(x)") // tainted

  sink(arg: "\(x) \(x)") // tainted

  sink(arg: "\(x) \(0) \(x)") // tainted

  var y = 42
  sink(arg: "\(y)") // clean

  sink(arg: "\(x) hello \(y)") // tainted

  sink(arg: "\(y) world \(x)") // tainted

  x = 0
  sink(arg: "\(x)") // clean
}