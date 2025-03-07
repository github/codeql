/**
 * @name Uncontrolled data used in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id rust/path-injection
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 *       external/cwe/cwe-099
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.TaintedPathExtensions
import TaintedPathFlow::PathGraph

/**
 * A taint configuration for tainted data that reaches a file access sink.
 */
module TaintedPathConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof TaintedPath::Source }

  predicate isSink(DataFlow::Node node) { node instanceof TaintedPath::Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof TaintedPath::Barrier }
}

module TaintedPathFlow = TaintTracking::Global<TaintedPathConfig>;

from TaintedPathFlow::PathNode source, TaintedPathFlow::PathNode sink
where TaintedPathFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This path depends on a $@.", source.getNode(),
  "user-provided value"
