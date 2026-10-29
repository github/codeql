import codeql.ruby.frameworks.core.BasicObject::BasicObject
import codeql.ruby.DataFlow

query DataFlow::Node instanceEvalCallCodeExecutions(InstanceEvalCallCodeExecution e) {
  result = e.getCode()
}
