import codeql.ruby.AST
import codeql.ruby.frameworks.PosixSpawn
import codeql.ruby.DataFlow

query predicate systemCalls(
  PosixSpawn::SystemCall call, DataFlow::Node arg, boolean shellInterpreted
) {
  call.isShellInterpreted(arg) and shellInterpreted = true
  or
  not call.isShellInterpreted(arg) and arg = call.getAnArgument() and shellInterpreted = false
}

query predicate childCalls(PosixSpawn::ChildCall call, DataFlow::Node arg, boolean shellInterpreted) {
  call.isShellInterpreted(arg) and shellInterpreted = true
  or
  not call.isShellInterpreted(arg) and arg = call.getAnArgument() and shellInterpreted = false
}
