import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.FlowSource

class Read extends AliasFunction, RemoteFlowFunction {
  Read() { this.hasGlobalName(["read", "pread"]) }

  override predicate parameterNeverEscapes(int n) { n = 0 }

  override predicate parameterEscapesOnlyViaReturn(int n) { none() }

  override predicate parameterIsAlwaysReturned(int n) { none() }

  override predicate hasRemoteFlowSource(FunctionOutput output, string description) {
    output.isParameterDeref(1) and
    description = "String read by " + this.getName()
  }
}
