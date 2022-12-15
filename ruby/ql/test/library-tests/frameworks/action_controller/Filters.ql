private import codeql.ruby.AST
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.DataFlow

query predicate filterChain = ActionController::Filters::next/3;

query predicate additionalFlowSteps = ActionController::Filters::additionalJumpStep/2;
