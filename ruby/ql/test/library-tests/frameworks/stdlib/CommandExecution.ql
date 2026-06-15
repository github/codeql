import codeql.ruby.Frameworks
import codeql.ruby.Concepts
import codeql.ruby.DataFlow

query predicate commandExecutions(
  SystemCommandExecution execution, DataFlow::Node arg, boolean isShellInterpreted
) {
  arg = execution.getAnArgument() and
  if execution.isShellInterpreted(arg)
  then isShellInterpreted = true
  else isShellInterpreted = false
}
