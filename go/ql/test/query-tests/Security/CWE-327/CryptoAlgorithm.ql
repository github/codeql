import go
import ModelValidation
import utils.test.InlineExpectationsTest

module Test implements TestSig {
  string getARelevantTag() { result = "CryptographicOperation" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "CryptographicOperation" and
    exists(
      CryptographicOperation::Range ho, string algorithm, string initialization, string blockMode
    |
      algorithm = ho.getAlgorithm().toString() + "." and
      (
        blockMode = " blockMode: " + ho.getBlockMode().toString() + "."
        or
        not exists(ho.getBlockMode()) and blockMode = ""
      ) and
      exists(int c | c = count(ho.getInitialization()) |
        c = 0 and initialization = ""
        or
        c > 0 and
        initialization =
          " init from " +
            strictconcat(DataFlow::Node init, int n |
              init = ho.getInitialization() and
              n = ho.getStartLine() - init.getStartLine()
            |
              n.toString(), ","
            ) + " lines above."
      ) and
      ho.getLocation() = location and
      element = ho.toString() and
      value = "\"" + algorithm + blockMode + initialization + "\""
    )
  }
}

import MakeTest<Test>
