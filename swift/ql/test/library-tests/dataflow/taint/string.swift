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

func source2() -> String { return ""; }

func taintThroughStringConcatenation() {
  var clean = "abcdef"
  var tainted = source2()

  sink(arg: clean)
  sink(arg: tainted) // tainted

  sink(arg: clean + clean)
  sink(arg: clean + tainted) // tainted
  sink(arg: tainted + clean) // tainted
  sink(arg: tainted + tainted) // tainted

  sink(arg: ">" + clean + "<")
  sink(arg: ">" + tainted + "<") // tainted

  var str = "abc"

  sink(arg: str)

  str += "def"
  sink(arg: str)

  str += source2()
  sink(arg: str) // tainted [NOT DETECTED]

  var str2 = "abc"

  sink(arg: str2)

  str2.append("def")
  sink(arg: str2)

  str2.append(source2())
  sink(arg: str2) // tainted [NOT DETECTED]

  var str3 = "abc"

  sink(arg: str3)

  str3.append(contentsOf: "def")
  sink(arg: str3)

  str3.append(contentsOf: source2())
  sink(arg: str2) // tainted [NOT DETECTED]
}

func taintThroughStringOperations() {
  var clean = ""
  var tainted = source2()
  var taintedInt = source()

  sink(arg: String(clean))
  sink(arg: String(tainted)) // tainted [NOT DETECTED]
  sink(arg: String(taintedInt)) // tainted [NOT DETECTED]

  sink(arg: String(repeating: clean, count: 2))
  sink(arg: String(repeating: tainted, count: 2)) // tainted [NOT DETECTED]

  sink(arg: clean.description)
  sink(arg: tainted.description) // tainted [NOT DETECTED]
  
  sink(arg: clean.debugDescription)
  sink(arg: tainted.debugDescription) // tainted [NOT DETECTED]
}
