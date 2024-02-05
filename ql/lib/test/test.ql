import codeql.actions.ast.internal.Actions
import codeql.actions.Ast
import codeql.actions.Cfg as Cfg
import codeql.actions.DataFlow
import codeql.Locations

query predicate files(File f) { any() }

query predicate yamlNodes(YamlNode n) { any() }

query predicate jobNodes(JobStmt s) { any() }

query predicate stepNodes(StepStmt s) { any() }

query predicate usesNodes(UsesExpr s) { any() }

query predicate usesSteps(UsesExpr call, string argname, Expression arg) {
  call.getArgument(argname) = arg
}

query predicate runSteps1(RunExpr run, string body) { run.getScript() = body }

query predicate runSteps2(RunExpr run, Expression bodyExpr) { run.getScriptExpr() = bodyExpr }

query predicate runStepChildren(RunExpr run, AstNode child) { child.getParentNode() = run }

query predicate varAccesses(ExprAccessExpr ea, string expr) { expr = ea.getExpression() }

query predicate outputAccesses(StepOutputAccessExpr va, string id, string var) {
  id = va.getStepId() and var = va.getVarName()
}

query predicate orphanVarAccesses(ExprAccessExpr va, string var) {
  var = va.getExpression() and
  not exists(AstNode n | n = va.getParentNode())
}

query predicate nonOrphanVarAccesses(ExprAccessExpr va, string var, AstNode parent) {
  var = va.getExpression() and
  parent = va.getParentNode()
}

query predicate parentNodes(AstNode child, AstNode parent) { child.getParentNode() = parent }

query predicate cfgNodes(Cfg::Node n) { any() }

query predicate dfNodes(DataFlow::Node e) { any() }

query predicate exprNodes(DataFlow::ExprNode e) { any() }

query predicate argumentNodes(DataFlow::ArgumentNode e) { any() }

query predicate localFlow(UsesExpr s, StepOutputAccessExpr o) { s.getId() = o.getStepId() }

query predicate usesIds(UsesExpr s, string a) { s.getId() = a }

query predicate varIds(StepOutputAccessExpr s, string a) { s.getStepId() = a }

query predicate nodeLocations(DataFlow::Node n, Location l) { n.getLocation() = l }
