import codeql.actions.Ast
import codeql.actions.Cfg as Cfg

query predicate roots(int workflows, int compositeActions) {
  workflows =
    strictcount(Workflow workflow | workflow.getLocation().getFile().getBaseName() = "action.yml") and
  compositeActions =
    strictcount(CompositeAction action | action.getLocation().getFile().getBaseName() = "action.yml")
}

query predicate cfgScopes(Cfg::CfgScope scope, string kind) {
  scope.getLocation().getFile().getBaseName() = "action.yml" and
  (
    scope instanceof Cfg::WorkflowScope and kind = "workflow"
    or
    scope instanceof Cfg::CompositeActionScope and kind = "composite action"
  )
}

query predicate cfgConsistency(string query, int results) {
  Cfg::Consistency::consistencyOverview(query, results) and
  results != 0
}
