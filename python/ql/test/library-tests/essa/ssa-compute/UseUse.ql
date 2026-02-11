import python
import semmle.python.essa.SsaCompute
import utils.test.InlineExpectationsTest

module UseTest implements TestSig {
  string getARelevantTag() { result in ["use-use", "def-use", "def"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(string name | name in ["x", "y"] |
      exists(NameNode nodeTo, Location prevLoc |
        (
          exists(NameNode nodeFrom | AdjacentUses::adjacentUseUse(nodeFrom, nodeTo) |
            prevLoc = nodeFrom.getLocation() and
            name = nodeFrom.getId() and
            tag = "use-use"
          )
          or
          exists(EssaVariable var | AdjacentUses::firstUse(var, nodeTo) |
            prevLoc = var.getLocation() and
            name = var.getName() and
            tag = "def-use"
          )
        ) and
        value = name + ":" + prevLoc.getStartLine() and
        location = nodeTo.getLocation() and
        element = nodeTo.toString()
      )
      or
      exists(EssaVariable var | AdjacentUses::firstUse(var, _) |
        value = var.getName() and
        location = var.getLocation() and
        element = var.getName() and
        name = var.getName() and
        tag = "def"
      )
    )
  }
}

import MakeTest<UseTest>
