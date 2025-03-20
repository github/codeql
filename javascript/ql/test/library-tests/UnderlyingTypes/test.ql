import javascript
private import utils.test.InlineExpectationsTest

bindingset[x, y]
private string join(string x, string y) {
  if x = "" or y = "" then result = x + y else result = x + "." + y
}

module TestConfig implements TestSig {
  string getARelevantTag() { result = "hasUnderlyingType" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    element = "" and
    tag = "hasUnderlyingType" and
    exists(DataFlow::SourceNode sn | location = sn.getLocation() |
      sn.hasUnderlyingType(value)
      or
      exists(string mod, string name |
        sn.hasUnderlyingType(mod, name) and
        value = join("'" + mod + "'", name)
      )
    )
  }
}

import MakeTest<TestConfig>
