func source() -> Int { return 0; }
func sink(arg: String) {}

func taintThroughInterpolatedStrings() {
  var x = source()

  sink(arg: "\(x)") // $ tainted=5

  sink(arg: "\(x) \(x)") // $ tainted=5

  sink(arg: "\(x) \(0) \(x)") // $ tainted=5

  var y = 42
  sink(arg: "\(y)") // clean

  sink(arg: "\(x) hello \(y)") // $ tainted=5

  sink(arg: "\(y) world \(x)") // $ tainted=5

  x = 0
  sink(arg: "\(x)") // clean
}

func source2() -> String { return ""; }

func taintThroughStringConcatenation() {
  var clean = "abcdef"
  var tainted = source2()

  sink(arg: clean)
  sink(arg: tainted) // $ tainted=28

  sink(arg: clean + clean)
  sink(arg: clean + tainted) // $ tainted=28
  sink(arg: tainted + clean) // $ tainted=28
  sink(arg: tainted + tainted) // $ tainted=28

  sink(arg: ">" + clean + "<")
  sink(arg: ">" + tainted + "<") // $ tainted=28

  var str = "abc"

  sink(arg: str)

  str += "def"
  sink(arg: str)

  str += source2()
  sink(arg: str) // $ MISSING: tainted=48

  var str2 = "abc"

  sink(arg: str2)

  str2.append("def")
  sink(arg: str2)

  str2.append(source2())
  sink(arg: str2) // $ MISSING: tainted=58

  var str3 = "abc"

  sink(arg: str3)

  str3.append(contentsOf: "def")
  sink(arg: str3)

  str3.append(contentsOf: source2())
  sink(arg: str2) // $ MISSING: tainted=68
}

func taintThroughStringOperations() {
  var clean = ""
  var tainted = source2()
  var taintedInt = source()

  sink(arg: String(clean))
  sink(arg: String(tainted)) // $ MISSING: tainted=74
  sink(arg: String(taintedInt)) // $ MISSING: tainted=75

  sink(arg: String(repeating: clean, count: 2))
  sink(arg: String(repeating: tainted, count: 2)) // $ MISSING: tainted=74

  sink(arg: clean.description)
  sink(arg: tainted.description) // $ MISSING: tainted=74

  sink(arg: clean.debugDescription)
  sink(arg: tainted.debugDescription) // $ MISSING: tainted=74
}
