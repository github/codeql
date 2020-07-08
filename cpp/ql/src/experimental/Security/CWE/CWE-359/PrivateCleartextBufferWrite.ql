/**
 * @name Cleartext storage of private data in buffer
 * @description Storing private data in cleartext can expose it
 *              to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @id cpp/private-cleartext-storage-buffer
 * @tags security
 *       external/cwe/cwe-312
 */


import cpp
import semmle.code.cpp.security.BufferWrite
import experimental.semmle.code.cpp.security.PrivateData
import semmle.code.cpp.dataflow.TaintTracking

/** A call to any method whose name suggests that it encodes or encrypts the parameter. */
class ProtectSanitizer extends DataFlow::ExprNode {
  ProtectSanitizer() {
    exists(Function m, string s |
      this.getExpr().(FunctionCall).getTarget() = m and
      m.getName().regexpMatch("(?i).*" + s + ".*")
    |
      s = "protect" or s = "encode" or s = "encrypt"
    )
  }
}

class BufferConfig extends TaintTracking::Configuration {
  BufferConfig() {
    this = "Buffer store configuration"
  }
  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof PrivateDataExpr }
  override predicate isSink(DataFlow::Node sink) { exists(BufferWrite w | sink.asExpr() = w.getDest()) }
  override predicate isSanitizer(DataFlow::Node node) { node instanceof ProtectSanitizer }
}

from
  BufferWrite w, BufferConfig b, Expr taintedArg, DataFlow::Node source, DataFlow::Node sink
where
  b.hasFlow(source, sink) and
  w.getASource() = taintedArg
select w, source, sink, "This write into this buffer may contain unencrypted data"




// import cpp
// import semmle.code.cpp.security.BufferWrite
// import semmle.code.cpp.security.TaintTracking
// import experimental.semmle.code.cpp.security.PrivateData
// import TaintedWithPath

// class Configuration extends TaintTrackingConfiguration {
//   override predicate isSink(Element tainted) { exists(BufferWrite w | w.getASource() = tainted) }
// }

// from
//   BufferWrite w, Expr taintedArg, Expr taintSource, PathNode sourceNode, PathNode sinkNode,
//   string taintCause, PrivateDataExpr dest
// where
//   taintedWithPath(taintSource, taintedArg, sourceNode, sinkNode) and
//   isUserInput(taintSource, taintCause) and
//   w.getASource() = taintedArg and
//   dest = w.getDest()
// select w, sourceNode, sinkNode,
//   "This write into buffer '" + dest.toString() + "' may contain unencrypted data from $@",
//   taintSource, "user input (" + taintCause + ")"
