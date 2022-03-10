import codeql.ruby.frameworks.core.Kernel::Kernel
import codeql.ruby.DataFlow

query predicate kernelSystemCallExecutions(KernelSystemCall c) { any() }

query predicate kernelExecCallExecutions(KernelExecCall c) { any() }

query predicate kernelSpawnCallExecutions(KernelSpawnCall c) { any() }

query predicate kernelOpenCallExecutions(KernelOpenCall c, DataFlow::Node arg) {
  c.isShellInterpreted(arg)
}

query DataFlow::Node sendCallCodeExecutions(SendCallCodeExecution e) { result = e.getCode() }

query DataFlow::Node evalCallCodeExecutions(EvalCallCodeExecution e) { result = e.getCode() }
