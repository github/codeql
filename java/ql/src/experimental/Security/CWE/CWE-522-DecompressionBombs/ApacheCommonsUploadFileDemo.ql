/**
 * @name Unsafe file write from a remotely provided path.
 * @description using apache commons upload file write sink is dangerous without sanitization
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-file-write
 * @tags security
 *       experimental
 */

import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import RemoteSource

module ApacheCommonsUploadFileConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof FormRemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(ApacheCommonsFileUpload::DangerousSink::FileWriteSink s).getAPathArgument()
  }
}

module BombsFlow = TaintTracking::Global<ApacheCommonsUploadFileConfig>;

import BombsFlow::PathGraph

from BombsFlow::PathNode source, BombsFlow::PathNode sink
where BombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
