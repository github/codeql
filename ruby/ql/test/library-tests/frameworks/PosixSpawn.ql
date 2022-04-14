import ruby
import codeql.ruby.frameworks.PosixSpawn
import codeql.ruby.DataFlow

query predicate systemCalls(PosixSpawn::SystemCall call, DataFlow::Node arg) {
  arg = call.getAnArgument()
}

query predicate childCalls(PosixSpawn::ChildCall call, DataFlow::Node arg) {
  arg = call.getAnArgument()
}
