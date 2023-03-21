/**
 * @kind path-problem
 */

import ruby
import TestUtilities.InlineFlowTest
import PathGraph
import codeql.ruby.frameworks.Sinatra
import codeql.ruby.Concepts

class SinatraConf extends DefaultTaintFlowConf {
  override predicate isSource(DataFlow::Node source) {
    source instanceof Http::Server::RequestInputAccess::Range
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, SinatraConf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
