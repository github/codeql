private import codeql.ruby.AST
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.DataFlow

// Flip the params around so results are grouped by action.
query predicate filterChain(ActionControllerActionMethod action, Method pred, Method succ) {
  ActionController::Filters::next(pred, succ, action)
}

query predicate additionalFlowSteps = ActionController::Filters::additionalJumpStep/2;
