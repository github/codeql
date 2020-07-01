/**
 * @name Cleartext storage of sensitive information in buffer
 * @description Storing sensitive information in cleartext can expose it
 *              to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/cleartext-storage-buffer
 * @tags security
 *       external/cwe/cwe-312
 */

import cpp
import semmle.code.cpp.security.BufferWrite
import semmle.code.cpp.security.TaintTracking
import semmle.code.cpp.security.SensitiveExprs
import TaintedWithPath

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element tainted) { exists(BufferWrite w | w.getASource() = tainted) }
}

from
  BufferWrite w, Expr taintedArg, Expr taintSource, PathNode sourceNode, PathNode sinkNode,
  string taintCause, SensitiveExpr dest
where
  taintedWithPath(taintSource, taintedArg, sourceNode, sinkNode) and
  isUserInput(taintSource, taintCause) and
  w.getASource() = taintedArg and
  dest = w.getDest()
select w, sourceNode, sinkNode,
  "This write into buffer '" + dest.toString() + "' may contain unencrypted data from $@",
  taintSource, "user input (" + taintCause + ")"
