import codeql.ruby.AST
import codeql.ruby.DataFlow
import PathGraph
import TestUtilities.InlineFlowTest
import codeql.ruby.security.InsecureDownloadQuery

class FlowTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { result = any(Configuration config) }

  override DataFlow::Configuration getTaintFlowConfig() { none() }

  override string getARelevantTag() { result = "BAD" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "BAD" and
    super.hasActualResult(location, element, "hasValueFlow", value)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Configuration conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
