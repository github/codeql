import codeql.ruby.frameworks.StandardLibrary

query predicate subshellLiteralExecutions(SubshellLiteralExecution e) { any() }

query predicate subshellHeredocExecutions(SubshellHeredocExecution e) { any() }

query predicate kernelSystemCallExecutions(KernelSystemCall c) { any() }

query predicate kernelExecCallExecutions(KernelExecCall c) { any() }

query predicate kernelSpawnCallExecutions(KernelSpawnCall c) { any() }

query predicate open3CallExecutions(Open3Call c) { any() }

query predicate open3PipelineCallExecutions(Open3PipelineCall c) { any() }

query predicate evalCallCodeExecutions(EvalCallCodeExecution e) { any() }

query predicate sendCallCodeExecutions(SendCallCodeExecution e) { any() }
