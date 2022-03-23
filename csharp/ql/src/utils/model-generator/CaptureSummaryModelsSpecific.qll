/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

import csharp
import semmle.code.csharp.dataflow.TaintTracking
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
import semmle.code.csharp.dataflow.internal.DataFlowPrivate
import ModelGeneratorUtils

/**
 * Gets the enclosing callable of `ret`.
 */
Callable returnNodeEnclosingCallable(ReturnNodeExt ret) { result = getNodeEnclosingCallable(ret) }

/**
 * Holds if `node` is an own instance access.
 */
predicate isOwnInstanceAccessNode(ReturnNode node) { node.asExpr() instanceof ThisAccess }

/**
 * Gets the CSV string representation of the qualifier.
 */
string qualifierString() { result = "Argument[Qualifier]" }
