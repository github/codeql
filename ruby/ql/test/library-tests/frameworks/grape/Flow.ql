/**
 * @kind path-problem
 */

import ruby
import utils.test.InlineFlowTest
import PathGraph
import codeql.ruby.frameworks.Grape
import codeql.ruby.Concepts

module GrapeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof Http::Server::RequestInputAccess::Range
    or
    DefaultFlowConfig::isSource(source)
  }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }
}

import FlowTest<DefaultFlowConfig, GrapeConfig>

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
