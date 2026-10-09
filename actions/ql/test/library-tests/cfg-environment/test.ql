import codeql.actions.Ast
import codeql.actions.Cfg as Cfg

query predicate envCfgNodes(Expression expression) {
  expression = any(Env env).getAnEnvVarExpr() and
  exists(Cfg::AstCfgNode node | node.getAstNode() = expression)
}

query predicate cfgCycles(Cfg::Node node) { node.getASuccessor+() = node }
