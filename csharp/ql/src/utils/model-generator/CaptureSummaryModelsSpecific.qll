/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

import csharp
import semmle.code.csharp.dataflow.TaintTracking
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
import semmle.code.csharp.dataflow.internal.DataFlowPrivate
import ModelGeneratorUtils

Callable returnNodeEnclosingCallable(ReturnNodeExt ret) { result = getNodeEnclosingCallable(ret) }

predicate isOwnInstanceAccessNode(ReturnNode node) { node.asExpr() instanceof ThisAccess }

string qualifierString() { result = "Argument[Qualifier]" }
