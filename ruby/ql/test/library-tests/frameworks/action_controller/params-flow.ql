/**
 * @kind path-problem
 */

import ruby
import TestUtilities.InlineFlowTest
import PathGraph
import codeql.ruby.frameworks.ActionController

class ParamsTaintFlowConf extends DefaultTaintFlowConf {
  override predicate isSource(DataFlow::Node n) { n.asExpr().getExpr() instanceof ParamsCall }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ParamsTaintFlowConf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
