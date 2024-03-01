import codeql.actions.ast.internal.Actions
import codeql.actions.Ast
import codeql.actions.Cfg as Cfg
import codeql.actions.DataFlow
import codeql.Locations
import codeql.actions.dataflow.ExternalFlow

query predicate files(File f) { any() }

query predicate yamlNodes(YamlNode n) { any() }

query predicate jobNodes(Job s) { any() }

query predicate stepNodes(Step s) { any() }

query predicate allUsesNodes(Uses s) { any() }

query predicate stepUsesNodes(StepUses s) { any() }

query predicate jobUsesNodes(JobUses s) { any() }

query predicate usesSteps(Uses call, string argname, Expression arg) {
  call.getArgumentExpr(argname) = arg
}

query predicate runSteps(Run run, string body) { run.getScript() = body }

query predicate runStepChildren(Run run, AstNode child) { child.getParentNode() = run }

query predicate parentNodes(AstNode child, AstNode parent) { child.getParentNode() = parent }

query predicate cfgNodes(Cfg::Node n) {
  n.getLocation().getFile().getBaseName() = "argus_case_study.yml"
} //any() }

query predicate dfNodes(DataFlow::Node e) {
  e.getLocation().getFile().getBaseName() = "argus_case_study.yml"
} //any() }

query predicate exprNodes(DataFlow::Node e) { any() }

query predicate argumentNodes(DataFlow::ArgumentNode e) { any() }

query predicate usesIds(StepUses s, string a) { s.getId() = a }

query predicate nodeLocations(DataFlow::Node n, Location l) { n.getLocation() = l }

query predicate scopes(Cfg::CfgScope c) { any() }

query predicate sources(string action, string version, string output, string trigger, string kind) {
  sourceModel(action, version, output, trigger, kind)
}

query predicate summaries(string action, string version, string input, string output, string kind) {
  summaryModel(action, version, input, output, kind)
}

query predicate calls(DataFlow::CallNode call, string callee) { callee = call.getCallee() }

query predicate needs(DataFlow::Node e) { e.asExpr() instanceof NeedsExpression }
