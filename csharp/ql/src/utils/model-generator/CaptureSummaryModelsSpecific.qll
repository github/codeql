import csharp
import semmle.code.csharp.dataflow.TaintTracking
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
import semmle.code.csharp.dataflow.internal.DataFlowPrivate
import ModelGeneratorUtils

predicate isOwnInstanceAccess(ReturnStmt rtn) { rtn.getExpr() instanceof ThisAccess }

predicate isOwnInstanceAccessNode(ReturnNode node) { node.asExpr() instanceof ThisAccess }

string qualifierString() { result = "Argument[Qualifier]" }
