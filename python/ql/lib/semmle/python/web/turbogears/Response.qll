import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.Http
import TurboGears

deprecated class ControllerMethodReturnValue extends HttpResponseTaintSink {
  override string toString() { result = "TurboGears ControllerMethodReturnValue" }

  ControllerMethodReturnValue() {
    exists(TurboGearsControllerMethod m |
      m.getAReturnValueFlowNode() = this and
      not m.isTemplated()
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }
}

deprecated class ControllerMethodTemplatedReturnValue extends HttpResponseTaintSink {
  override string toString() { result = "TurboGears ControllerMethodTemplatedReturnValue" }

  ControllerMethodTemplatedReturnValue() {
    exists(TurboGearsControllerMethod m |
      m.getAReturnValueFlowNode() = this and
      m.isTemplated()
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringDictKind }
}
