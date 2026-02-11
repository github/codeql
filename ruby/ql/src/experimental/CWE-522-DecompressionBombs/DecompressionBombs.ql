/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id rb/user-controlled-data-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import DecompressionBombs

/**
 * A call to `IO.copy_stream`
 */
class IoCopyStream extends DataFlow::CallNode {
  IoCopyStream() { this = API::getTopLevelMember("IO").getAMethodCall("copy_stream") }

  DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
}

module BombsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof DecompressionBomb::Sink }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(DecompressionBomb::AdditionalTaintStep ats).isAdditionalTaintStep(nodeFrom, nodeTo)
    or
    exists(API::Node n | n = API::getTopLevelMember("File").getMethod("open") |
      nodeFrom = n.getParameter(0).asSink() and
      nodeTo = n.getReturn().asSource()
    )
    or
    nodeFrom = nodeTo.(File::FileOpen).getAPathArgument()
    or
    exists(API::Node n | n = API::getTopLevelMember("StringIO").getMethod("new") |
      nodeFrom = n.getParameter(0).asSink() and
      nodeTo = n.getReturn().asSource()
    )
    or
    nodeFrom = nodeTo.(IoCopyStream).getAPathArgument()
    or
    // following can be a global additional step
    exists(DataFlow::CallNode cn |
      cn.getMethodName() = "open" and
      cn.getReceiver().getExprNode().getExpr() instanceof Ast::SelfVariableAccess
    |
      nodeFrom = cn.getArgument(0) and
      nodeTo = cn
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module Bombs = TaintTracking::Global<BombsConfig>;

import Bombs::PathGraph

from Bombs::PathNode source, Bombs::PathNode sink
where Bombs::flowPath(source, sink)
select sink.getNode(), source, sink, "This file Decompression depends on a $@.", source.getNode(),
  "potentially untrusted source"
