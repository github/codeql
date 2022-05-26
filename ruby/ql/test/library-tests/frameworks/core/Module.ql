import codeql.ruby.DataFlow
import codeql.ruby.frameworks.core.Module::Module

query DataFlow::Node classEvalCallCodeExecutions(ClassEvalCallCodeExecution e) {
  result = e.getCode()
}

query DataFlow::Node moduleEvalCallCodeExecutions(ModuleEvalCallCodeExecution e) {
  result = e.getCode()
}

query DataFlow::Node moduleConstGetCallCodeExecutions(ModuleConstGetCallCodeExecution e) {
  result = e.getCode()
}
