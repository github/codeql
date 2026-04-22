import semmle.code.powershell.controlflow.CfgNodes
import ExprNodes
import StmtNodes

query predicate forEach(ForEachStmtCfgNode forEach, ExprCfgNode va, ExprCfgNode iterable, StmtCfgNode body) {
  va = forEach.getVarAccess() and
  iterable = forEach.getIterableExpr() and
  body = forEach.getBody()
}

query predicate objectCreation(ObjectCreationCfgNode oc, int i, ExprCfgNode argument) {
  argument = oc.getArgument(i)
}