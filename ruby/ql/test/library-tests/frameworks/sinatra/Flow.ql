/**
 * @kind path-problem
 */

import ruby
import TestUtilities.InlineFlowTest
import PathGraph
import codeql.ruby.frameworks.Sinatra
import codeql.ruby.Concepts

class ParamsTaintFlowConf extends DefaultTaintFlowConf {
  override predicate isSource(DataFlow::Node n) { n instanceof Http::Server::RequestInputAccess }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ParamsTaintFlowConf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
