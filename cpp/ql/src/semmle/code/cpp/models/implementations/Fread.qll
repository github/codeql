import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.FlowSource

private class Fread extends AliasFunction, RemoteFlowSourceFunction {
  Fread() { this.hasGlobalOrStdOrBslName("fread") }

  override predicate parameterNeverEscapes(int n) {
    n = 0 or
    n = 3
  }

  override predicate parameterEscapesOnlyViaReturn(int n) { none() }

  override predicate parameterIsAlwaysReturned(int n) { none() }

  override predicate hasRemoteFlowSource(FunctionOutput output, string description) {
    output.isParameterDeref(0) and
    description = "String read by " + this.getName()
  }
}
