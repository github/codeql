import codeql.ruby.controlflow.CfgNodes
import codeql.ruby.controlflow.CfgNodes::ExprNodes

query predicate callsWithNoArguments(CallCfgNode c) {
  not exists(c.getArgument(_)) and not exists(c.getKeywordArgument(_))
}

query predicate positionalArguments(CallCfgNode c, ExprCfgNode arg) { arg = c.getArgument(_) }

query predicate keywordArguments(CallCfgNode c, string keyword, ExprCfgNode arg) {
  arg = c.getKeywordArgument(keyword)
}
