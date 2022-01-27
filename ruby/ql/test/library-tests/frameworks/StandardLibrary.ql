import codeql.ruby.frameworks.StandardLibrary
import codeql.ruby.DataFlow

query predicate subshellLiteralExecutions(SubshellLiteralExecution e) { any() }

query predicate subshellHeredocExecutions(SubshellHeredocExecution e) { any() }

query predicate kernelSystemCallExecutions(KernelSystemCall c) { any() }

query predicate kernelExecCallExecutions(KernelExecCall c) { any() }

query predicate kernelSpawnCallExecutions(KernelSpawnCall c) { any() }

query predicate open3CallExecutions(Open3Call c) { any() }

query predicate open3PipelineCallExecutions(Open3PipelineCall c) { any() }

query DataFlow::Node evalCallCodeExecutions(EvalCallCodeExecution e) { result = e.getCode() }

query DataFlow::Node sendCallCodeExecutions(SendCallCodeExecution e) { result = e.getCode() }

query DataFlow::Node instanceEvalCallCodeExecutions(InstanceEvalCallCodeExecution e) {
  result = e.getCode()
}

query DataFlow::Node classEvalCallCodeExecutions(ClassEvalCallCodeExecution e) {
  result = e.getCode()
}

query DataFlow::Node moduleEvalCallCodeExecutions(ModuleEvalCallCodeExecution e) {
  result = e.getCode()
}

query DataFlow::Node loggerLoggingCallInputs(LoggerLoggingCall c) { result = c.getAnInput() }

query DataFlow::Node moduleConstGetCallCodeExecutions(ModuleConstGetCallCodeExecution e) {
  result = e.getCode()
}
