import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.FlowSource

class Fread extends AliasFunction, RemoteFlowFunction {
  Fread() { this.hasGlobalName("fread") }

  override predicate parameterNeverEscapes(int n) {
    n = 0 or
    n = 3
  }

  override predicate parameterEscapesOnlyViaReturn(int n) { none() }

  override predicate parameterIsAlwaysReturned(int n) { none() }

  override predicate hasFlowSource(FunctionOutput output) {
    output.isParameterDeref(0)
  }
}
