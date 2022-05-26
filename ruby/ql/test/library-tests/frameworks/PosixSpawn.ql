import ruby
import codeql.ruby.frameworks.PosixSpawn
import codeql.ruby.DataFlow

query predicate systemCalls(
  PosixSpawn::SystemCall call, DataFlow::Node arg, boolean shellInterpreted
) {
  arg = call.getAnArgument() and
  if call.isShellInterpreted(arg) then shellInterpreted = true else shellInterpreted = false
}

query predicate childCalls(PosixSpawn::ChildCall call, DataFlow::Node arg, boolean shellInterpreted) {
  arg = call.getAnArgument() and
  if call.isShellInterpreted(arg) then shellInterpreted = true else shellInterpreted = false
}
