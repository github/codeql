/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.internal.DataFlowImplCommon
import semmle.code.java.dataflow.internal.DataFlowNodes
import semmle.code.java.dataflow.internal.DataFlowPrivate
import semmle.code.java.dataflow.InstanceAccess
import ModelGeneratorUtils

predicate isOwnInstanceAccess(ReturnStmt rtn) { rtn.getResult().(ThisAccess).isOwnInstanceAccess() }

predicate isOwnInstanceAccessNode(ReturnNode node) {
  node.asExpr().(ThisAccess).isOwnInstanceAccess()
}

string qualifierString() { result = "Argument[-1]" }
