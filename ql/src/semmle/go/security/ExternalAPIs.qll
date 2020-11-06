/**
 * Definitions for reasoning about untrusted data used in APIs defined outside the
 * database.
 */

import go

/**
 * A `Function` that is considered a "safe" external API from a security perspective.
 */
abstract class SafeExternalAPIFunction extends Function { }

/** The default set of "safe" external APIs. */
private class DefaultSafeExternalAPIFunction extends SafeExternalAPIFunction {
  DefaultSafeExternalAPIFunction() {
    this instanceof BuiltinFunction
    // TODO: Add more external API functions which we know are safe here
  }
}

/** A node representing data being passed to an external API. */
class ExternalAPIDataNode extends DataFlow::Node {
  DataFlow::CallNode call;
  int i;

  ExternalAPIDataNode() {
    (
      // Argument to call to a function
      this = call.getArgument(i)
      or
      // Receiver to a call to a method which returns non trivial value
      this = call.getReceiver() and
      i = -1 and
      (
        call.getTarget().getNumResult() >= 2
        or
        call.getTarget().getNumResult() = 1 and
        not call.getTarget().getResultType(0) instanceof BoolType
      )
    ) and
    // Not defined in the code that is being analysed
    not exists(call.getACallee().getBody()) and
    // Not already modeled as a taint step
    not exists(DataFlow::Node next | TaintTracking::localTaintStep(this, next)) and
    // Not a call to a known safe external API
    not call = any(SafeExternalAPIFunction f).getACall()
  }

  /** Gets the called API `Function`. */
  Function getFunction() { result.getACall() = call }

  /** Gets the index which is passed untrusted data (where -1 indicates the receiver). */
  int getIndex() { result = i }

  /** Gets the description of the function being called. */
  string getFunctionDescription() {
    // For methods, need to use `getReceiverBaseType` to avoid multiple values when the
    // receiver of the method is an embedded field in another type. Note also that
    // for non-methods, `getQualifiedName` isn't always defined, e.g. for built-in
    // functions or function variables. In those cases we cannot provide a package with
    // the function description.
    if this.getFunction() instanceof Method
    then
      result =
        this.getFunction().(Method).getReceiverBaseType().getQualifiedName() + "." +
          this.getFunction().getName()
    else
      if exists(this.getFunction().getQualifiedName())
      then result = this.getFunction().getQualifiedName()
      else result = call.getCalleeName()
  }
}

/** A configuration for tracking flow from `RemoteFlowSource`s to `ExternalAPIDataNode`s. */
class UntrustedDataToExternalAPIConfig extends TaintTracking::Configuration {
  UntrustedDataToExternalAPIConfig() { this = "UntrustedDataToExternalAPIConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ExternalAPIDataNode }
}

/** A node representing untrusted data being passed to an external API. */
class UntrustedExternalAPIDataNode extends ExternalAPIDataNode {
  UntrustedExternalAPIDataNode() { any(UntrustedDataToExternalAPIConfig c).hasFlow(_, this) }

  /** Gets a source of untrusted data which is passed to this external API data node. */
  DataFlow::Node getAnUntrustedSource() {
    any(UntrustedDataToExternalAPIConfig c).hasFlow(result, this)
  }
}

private newtype TExternalAPI =
  TExternalAPIParameter(Function m, int index) {
    exists(UntrustedExternalAPIDataNode n |
      m = n.getFunction() and
      index = n.getIndex()
    )
  }

/** An external API which is used with untrusted data. */
class ExternalAPIUsedWithUntrustedData extends TExternalAPI {
  /** Gets a possibly untrusted use of this external API. */
  UntrustedExternalAPIDataNode getUntrustedDataNode() {
    this = TExternalAPIParameter(result.getFunction(), result.getIndex())
  }

  /** Gets the number of untrusted sources used with this external API. */
  int getNumberOfUntrustedSources() {
    result = count(getUntrustedDataNode().getAnUntrustedSource())
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(Function f, int index, string indexString |
      if index = -1 then indexString = "receiver" else indexString = "param " + index
    |
      this = TExternalAPIParameter(f, index) and
      if exists(f.getQualifiedName())
      then result = f.getQualifiedName() + " [" + indexString + "]"
      else result = f.getName() + " [" + indexString + "]"
    )
  }
}
