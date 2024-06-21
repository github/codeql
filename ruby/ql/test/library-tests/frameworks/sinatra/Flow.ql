/**
 * @kind path-problem
 */

import ruby
import TestUtilities.InlineFlowTest
import PathGraph
import codeql.ruby.frameworks.Sinatra
import codeql.ruby.Concepts

module SinatraConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof Http::Server::RequestInputAccess::Range
  }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }
}

import FlowTest<DefaultFlowConfig, SinatraConfig>

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
