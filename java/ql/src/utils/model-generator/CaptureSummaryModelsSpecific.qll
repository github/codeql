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

/**
 * Gets the enclosing callable of `ret`.
 */
Callable returnNodeEnclosingCallable(ReturnNodeExt ret) {
  result = getNodeEnclosingCallable(ret).asCallable()
}

/**
 * Holds if `node` is an own instance access.
 */
predicate isOwnInstanceAccessNode(ReturnNode node) {
  node.asExpr().(ThisAccess).isOwnInstanceAccess()
}

/**
 * Gets the CSV string representation of the qualifier.
 */
string qualifierString() { result = "Argument[-1]" }
