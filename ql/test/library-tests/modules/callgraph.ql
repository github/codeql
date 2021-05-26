import ruby
import codeql_ruby.dataflow.internal.DataFlowDispatch

query DataFlowCallable getTarget(DataFlowCall call) { result = call.getTarget() }

query predicate unresolvedCall(DataFlowCall call) { not exists(call.getTarget()) }
