import codeql.actions.Ast
import codeql.actions.Cfg as Cfg

query predicate envCfgNodes(Expression expression) {
  expression = any(Env env).getAnEnvVarExpr() and
  exists(Cfg::AstCfgNode node | node.getAstNode() = expression)
}

query predicate cfgCycles(Cfg::Node node) { node.getASuccessor+() = node }

query predicate cfgDeadEnds(Cfg::Node node) {
  not node instanceof Cfg::ExitNode and
  not exists(node.getASuccessor())
}

query predicate cfgConsistency(string query, int results) {
  Cfg::Consistency::consistencyOverview(query, results) and
  results != 0
}
