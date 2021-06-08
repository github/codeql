/**
 * Definitions for reasoning about untrusted data used in APIs defined outside the
 * database.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts
import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.python.dataflow.new.internal.TaintTrackingPrivate as TaintTrackingPrivate
private import semmle.python.types.Builtins
private import semmle.python.objects.ObjectInternal

// IMPLEMENTATION NOTES:
//
// This query uses *both* the new data-flow library, and points-to. Why? To get this
// finished quickly, so it can provide value for our field team and ourselves.
//
// In the long run, it should not need to use points-to for anything. Possibly this can
// even be helpful in figuring out what we need from TypeTrackers and the new data-flow
// library to be fully operational.
//
// At least it will allow us to provide a baseline comparison against a solution that
// doesn't use points-to at all
//
// There is a few dirty things we do here:
// 1. DataFlowPrivate: since `DataFlowCall` and `DataFlowCallable` are not exposed
//    publicly, but we really want access to them.
// 2. points-to: we kinda need to do this since this is what powers `DataFlowCall` and
//    `DataFlowCallable`
// 3. ObjectInternal: to provide better names for built-in functions and methods. If we
//    really wanted to polish our points-to implementation, we could move this
//    functionality into `BuiltinFunctionValue` and `BuiltinMethodValue`, but will
//    probably require some more work: for this query, it's totally ok to use
//    `builtins.open` for the code `open(f)`, but well, it requires a bit of thinking to
//    figure out if that is desireable in general. I simply skipped a corner here!
// 4. TaintTrackingPrivate: Nothing else gives us access to `defaultAdditionalTaintStep` :(
/**
 * A callable that is considered a "safe" external API from a security perspective.
 */
class SafeExternalAPI extends Unit {
  /** Gets a callable that is considered a "safe" external API from a security perspective. */
  abstract DataFlowPrivate::DataFlowCallable getSafeCallable();
}

/** The default set of "safe" external APIs. */
private class DefaultSafeExternalAPI extends SafeExternalAPI {
  override DataFlowPrivate::DataFlowCallable getSafeCallable() {
    exists(CallableValue cv | cv = result.getCallableValue() |
      cv = Value::named(["len", "isinstance", "getattr", "hasattr"])
      or
      exists(ClassValue cls, string attr |
        cls = Value::named("dict") and attr in ["__getitem__", "__setitem__"]
      |
        cls.lookup(attr) = cv
      )
    )
  }
}

/** A node representing data being passed to an external API through a call. */
class ExternalAPIDataNode extends DataFlow::Node {
  DataFlowPrivate::DataFlowCall call;
  DataFlowPrivate::DataFlowCallable callable;
  int i;

  ExternalAPIDataNode() {
    exists(call.getLocation().getFile().getRelativePath()) and
    callable = call.getCallable() and
    not any(SafeExternalAPI safe).getSafeCallable() = callable and
    exists(Value cv | cv = callable.getCallableValue() |
      cv.isAbsent()
      or
      cv.isBuiltin()
      or
      cv.(CallableValue).getScope().getLocation().getFile().inStdlib()
      or
      not exists(cv.(CallableValue).getScope().getLocation().getFile().getRelativePath())
    ) and
    // TODO: this ignores some complexity of keyword arguments (especially keyword-only args)
    this = call.getArg(i) and
    // Not already modeled as a taint step
    not exists(DataFlow::Node next | TaintTrackingPrivate::defaultAdditionalTaintStep(this, next)) and
    // for `list.append(x)`, we have a additional taint step from x -> [post] list.
    // Since we have modeled this explicitly, I don't see any cases where we would want to report this.
    not exists(DataFlow::Node prev, DataFlow::PostUpdateNode post |
      post.getPreUpdateNode() = this and
      TaintTrackingPrivate::defaultAdditionalTaintStep(prev, post)
    )
  }

  /** Gets the index for the parameter that will receive this untrusted data */
  int getIndex() { result = i }

  /** Gets the callable to which this argument is passed. */
  DataFlowPrivate::DataFlowCallable getCallable() { result = callable }
}

/** A configuration for tracking flow from `RemoteFlowSource`s to `ExternalAPIDataNode`s. */
class UntrustedDataToExternalAPIConfig extends TaintTracking::Configuration {
  UntrustedDataToExternalAPIConfig() { this = "UntrustedDataToExternalAPIConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

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
  TExternalAPIParameter(DataFlowPrivate::DataFlowCallable callable, int index) {
    exists(UntrustedExternalAPIDataNode n |
      callable = n.getCallable() and
      index = n.getIndex()
    )
  }

/** An external API which is used with untrusted data. */
class ExternalAPIUsedWithUntrustedData extends TExternalAPI {
  /** Gets a possibly untrusted use of this external API. */
  UntrustedExternalAPIDataNode getUntrustedDataNode() {
    this = TExternalAPIParameter(result.getCallable(), result.getIndex())
  }

  /** Gets the number of untrusted sources used with this external API. */
  int getNumberOfUntrustedSources() {
    result = count(getUntrustedDataNode().getAnUntrustedSource())
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(
      DataFlowPrivate::DataFlowCallable callable, int index, string callableString,
      string indexString
    |
      this = TExternalAPIParameter(callable, index) and
      indexString = "param " + index and
      exists(CallableValue cv | cv = callable.getCallableValue() |
        callableString =
          cv.getScope().getEnclosingModule().getName() + "." + cv.getScope().getQualifiedName()
        or
        not exists(cv.getScope()) and
        (
          cv instanceof BuiltinFunctionValue and
          callableString = pretty_builtin_function_value(cv)
          or
          cv instanceof BuiltinMethodValue and
          callableString = pretty_builtin_method_value(cv)
          or
          not cv instanceof BuiltinFunctionValue and
          not cv instanceof BuiltinMethodValue and
          callableString = cv.toString()
        )
      ) and
      result = callableString + " [" + indexString + "]"
    )
  }
}

/** Gets the fully qualified name for the `BuiltinFunctionValue` bfv. */
private string pretty_builtin_function_value(BuiltinFunctionValue bfv) {
  exists(Builtin b | b = bfv.(BuiltinFunctionObjectInternal).getBuiltin() |
    result = prefix_with_module_if_found(b)
  )
}

/** Gets the fully qualified name for the `BuiltinMethodValue` bmv. */
private string pretty_builtin_method_value(BuiltinMethodValue bmv) {
  exists(Builtin b | b = bmv.(BuiltinMethodObjectInternal).getBuiltin() |
    exists(Builtin cls | cls.isClass() and cls.getMember(b.getName()) = b |
      result = prefix_with_module_if_found(cls) + "." + b.getName()
    )
    or
    not exists(Builtin cls | cls.isClass() and cls.getMember(b.getName()) = b) and
    result = b.getName()
  )
}

/** Helper predicate that tries to adds module qualifier to `b`. Will succeed even if module not found. */
private string prefix_with_module_if_found(Builtin b) {
  exists(Builtin mod | mod.isModule() and mod.getMember(b.getName()) = b |
    result = mod.getName() + "." + b.getName()
  )
  or
  not exists(Builtin mod | mod.isModule() and mod.getMember(b.getName()) = b) and
  result = b.getName()
}
