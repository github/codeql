func source() -> Int { return 0; }
func sink(arg: String) {}

func taintThroughInterpolatedStrings() {
  var x = source()
  
  sink(arg: "\(x)") // $ taintedFromLine=5

  sink(arg: "\(x) \(x)") // $ taintedFromLine=5

  sink(arg: "\(x) \(0) \(x)") // $ taintedFromLine=5

  var y = 42
  sink(arg: "\(y)") // clean

  sink(arg: "\(x) hello \(y)") // $ taintedFromLine=5

  sink(arg: "\(y) world \(x)") // $ taintedFromLine=5

  x = 0
  sink(arg: "\(x)") // clean
}

func source2() -> String { return ""; }

func taintThroughStringConcatenation() {
  var clean = "abcdef"
  var tainted = source2()

  sink(arg: clean)
  sink(arg: tainted) // $ taintedFromLine=28

  sink(arg: clean + clean)
  sink(arg: clean + tainted) // $ taintedFromLine=28
  sink(arg: tainted + clean) // $ taintedFromLine=28
  sink(arg: tainted + tainted) // $ taintedFromLine=28

  sink(arg: ">" + clean + "<")
  sink(arg: ">" + tainted + "<") // $ taintedFromLine=28

  var str = "abc"

  sink(arg: str)

  str += "def"
  sink(arg: str)

  str += source2()
  sink(arg: str) // $ MISSING: taintedFromLine=48

  var str2 = "abc"

  sink(arg: str2)

  str2.append("def")
  sink(arg: str2)

  str2.append(source2())
  sink(arg: str2) // $ MISSING: taintedFromLine=58

  var str3 = "abc"

  sink(arg: str3)

  str3.append(contentsOf: "def")
  sink(arg: str3)

  str3.append(contentsOf: source2())
  sink(arg: str2) // $ MISSING: taintedFromLine=68
}

func taintThroughStringOperations() {
  var clean = ""
  var tainted = source2()
  var taintedInt = source()

  sink(arg: String(clean))
  sink(arg: String(tainted)) // $ MISSING: taintedFromLine=74
  sink(arg: String(taintedInt)) // $ MISSING: taintedFromLine=75

  sink(arg: String(repeating: clean, count: 2))
  sink(arg: String(repeating: tainted, count: 2)) // $ MISSING: taintedFromLine=74

  sink(arg: clean.description)
  sink(arg: tainted.description) // $ MISSING: taintedFromLine=74
  
  sink(arg: clean.debugDescription)
  sink(arg: tainted.debugDescription) // $ MISSING: taintedFromLine=74
}
