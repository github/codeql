import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.security.InsecureDownloadQuery
import Flow::PathGraph
import TestUtilities.InlineExpectationsTest
import TestUtilities.InlineFlowTestUtil

module FlowTest implements TestSig {
  string getARelevantTag() { result = "BAD" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "BAD" and
    exists(DataFlow::Node src, DataFlow::Node sink | Flow::flow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      if exists(getSourceArgString(src)) then value = getSourceArgString(src) else value = ""
    )
  }
}

import MakeTest<FlowTest>

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
