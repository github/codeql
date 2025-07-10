import codeql.ruby.security.InsecureDownloadQuery
import InsecureDownloadFlow::PathGraph
import utils.test.InlineExpectationsTest
import utils.test.InlineFlowTestUtil

module FlowTest implements TestSig {
  string getARelevantTag() { result = "BAD" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "BAD" and
    exists(DataFlow::Node src, DataFlow::Node sink | InsecureDownloadFlow::flow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      if exists(getSourceArgString(src)) then value = getSourceArgString(src) else value = ""
    )
  }
}

import MakeTest<FlowTest>

from InsecureDownloadFlow::PathNode source, InsecureDownloadFlow::PathNode sink
where InsecureDownloadFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
