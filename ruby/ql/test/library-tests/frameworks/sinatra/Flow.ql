/**
 * @kind path-problem
 */

import ruby
import TestUtilities.InlineFlowTest
import TaintFlow::PathGraph
import codeql.ruby.frameworks.Sinatra
import codeql.ruby.Concepts

module SinatraConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof Http::Server::RequestInputAccess::Range
  }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }
}

import FlowTest<DefaultFlowConfig, SinatraConfig>

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
