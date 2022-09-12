private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.frameworks.Railties
private import codeql.ruby.DataFlow

query predicate systemCommandExecutions(SystemCommandExecution e) { any() }

query predicate shellInterpretedArguments(SystemCommandExecution e, DataFlow::Node arg) {
  e.isShellInterpreted(arg)
}
