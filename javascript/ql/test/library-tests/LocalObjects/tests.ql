import javascript
import semmle.javascript.dataflow.LocalObjects

query predicate localObject_hasOwnProperty(LocalObject src, string name) {
  src.hasOwnProperty(name)
}

query predicate localObject(LocalObject obj) { any() }

query predicate methodCallTypeInference(DataFlow::MethodCallNode call, string types) {
  types = call.analyze().ppTypes()
}

query predicate methodCallTypeInferenceUsage(
  DataFlow::MethodCallNode call, DataFlow::Node use, AbstractValue val
) {
  call.flowsTo(use) and
  use != call and
  not exists(use.getASuccessor()) and
  val = use.analyze().getAValue()
}
