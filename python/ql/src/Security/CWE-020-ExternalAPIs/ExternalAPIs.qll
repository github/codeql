/**
 * Definitions for reasoning about untrusted data used in APIs defined outside the
 * user-written code.
 */

private import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.python.dataflow.new.internal.TaintTrackingPrivate as TaintTrackingPrivate

/**
 * An external API that is considered "safe" from a security perspective.
 */
class SafeExternalApi extends Unit {
  /**
   * Gets a call that is considered "safe" from a security perspective. You can use API
   * graphs to find calls to functions you know are safe.
   *
   * Which works even when the external library isn't extracted.
   */
  abstract DataFlow::CallCfgNode getSafeCall();

  /**
   * Gets a callable that is considered a "safe" external API from a security
   * perspective.
   *
   * You probably want to define this as `none()` and use `getSafeCall` instead, since
   * that can handle the external library not being extracted.
   */
  DataFlowPrivate::DataFlowCallable getSafeCallable() { none() }
}

/** The default set of "safe" external APIs. */
private class DefaultSafeExternalApi extends SafeExternalApi {
  override DataFlow::CallCfgNode getSafeCall() {
    result =
      API::builtin([
          "len", "enumerate", "isinstance", "getattr", "hasattr", "bool", "float", "int", "repr",
          "str", "type"
        ]).getACall()
  }
}

/**
 * Gets a human readable representation of `node`.
 *
 * Note that this is only defined for API nodes that are allowed as external APIs,
 * so `None.json.dumps` will for example not be allowed.
 */
string apiNodeToStringRepr(API::Node node) {
  node = API::builtin(result)
  or
  node = API::moduleImport(result)
  or
  exists(API::Node base, string basename |
    base.getDepth() < node.getDepth() and
    basename = apiNodeToStringRepr(base) and
    not base = API::builtin(["None", "True", "False"])
  |
    exists(string m | node = base.getMember(m) | result = basename + "." + m)
    or
    node = base.getReturn() and
    result = basename + "()" and
    not base.getACall() = any(SafeExternalApi safe).getSafeCall()
    or
    node = base.getAwaited() and
    result = basename
  )
}

predicate resolvedCall(CallNode call) {
  DataFlowPrivate::resolveCall(call, _, _) or
  DataFlowPrivate::resolveClassCall(call, _)
}

newtype TInterestingExternalApiCall =
  TUnresolvedCall(DataFlow::CallCfgNode call) {
    exists(call.getLocation().getFile().getRelativePath()) and
    not resolvedCall(call.getNode()) and
    not call = any(SafeExternalApi safe).getSafeCall()
  } or
  TResolvedCall(DataFlowPrivate::DataFlowCall call) {
    exists(call.getLocation().getFile().getRelativePath()) and
    exists(call.getCallable()) and
    not call.getCallable() = any(SafeExternalApi safe).getSafeCallable() and
    // ignore calls inside codebase, and ignore calls that are marked as  safe. This is
    // only needed as long as we extract dependencies. When we stop doing that, all
    // targets of resolved calls will be from user-written code.
    not exists(call.getCallable().getLocation().getFile().getRelativePath()) and
    not exists(DataFlow::CallCfgNode callCfgNode | callCfgNode.getNode() = call.getNode() |
      any(SafeExternalApi safe).getSafeCall() = callCfgNode
    )
  }

abstract class InterestingExternalApiCall extends TInterestingExternalApiCall {
  /** Gets the argument at position `apos`, if any */
  abstract DataFlow::Node getArgument(DataFlowPrivate::ArgumentPosition apos);

  /** Gets a textual representation of this element. */
  abstract string toString();

  /**
   * Gets a human-readable name for the external API.
   */
  abstract string getApiName();
}

class UnresolvedCall extends InterestingExternalApiCall, TUnresolvedCall {
  DataFlow::CallCfgNode call;

  UnresolvedCall() { this = TUnresolvedCall(call) }

  override DataFlow::Node getArgument(DataFlowPrivate::ArgumentPosition apos) {
    exists(int i | apos.isPositional(i) | result = call.getArg(i))
    or
    exists(string name | apos.isKeyword(name) | result = call.getArgByName(name))
  }

  override string toString() {
    result = "ExternalAPI:UnresolvedCall: " + call.getNode().getNode().toString()
  }

  override string getApiName() {
    exists(API::Node apiNode |
      result = apiNodeToStringRepr(apiNode) and
      apiNode.getACall() = call
    )
  }
}

class ResolvedCall extends InterestingExternalApiCall, TResolvedCall {
  DataFlowPrivate::DataFlowCall dfCall;

  ResolvedCall() { this = TResolvedCall(dfCall) }

  override DataFlow::Node getArgument(DataFlowPrivate::ArgumentPosition apos) {
    result = dfCall.getArgument(apos)
  }

  override string toString() {
    result = "ExternalAPI:ResolvedCall: " + dfCall.getNode().getNode().toString()
  }

  override string getApiName() {
    exists(DataFlow::CallCfgNode call, API::Node apiNode | dfCall.getNode() = call.getNode() |
      result = apiNodeToStringRepr(apiNode) and
      apiNode.getACall() = call
    )
  }
}

/** A node representing data being passed to an external API through a call. */
class ExternalApiDataNode extends DataFlow::Node {
  ExternalApiDataNode() {
    exists(InterestingExternalApiCall call | this = call.getArgument(_)) and
    // Not already modeled as a taint step
    not TaintTrackingPrivate::defaultAdditionalTaintStep(this, _, _) and
    // for `list.append(x)`, we have a additional taint step from x -> [post] list.
    // Since we have modeled this explicitly, I don't see any cases where we would want to report this.
    not exists(DataFlow::PostUpdateNode post |
      post.getPreUpdateNode() = this and
      TaintTrackingPrivate::defaultAdditionalTaintStep(_, post, _)
    )
  }
}

private module UntrustedDataToExternalApiConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ExternalApiDataNode }
}

/** Global taint-tracking from `RemoteFlowSource`s to `ExternalApiDataNode`s. */
module UntrustedDataToExternalApiFlow = TaintTracking::Global<UntrustedDataToExternalApiConfig>;

/** A node representing untrusted data being passed to an external API. */
class UntrustedExternalApiDataNode extends ExternalApiDataNode {
  UntrustedExternalApiDataNode() { UntrustedDataToExternalApiFlow::flow(_, this) }

  /** Gets a source of untrusted data which is passed to this external API data node. */
  DataFlow::Node getAnUntrustedSource() { UntrustedDataToExternalApiFlow::flow(result, this) }
}

/** An external API which is used with untrusted data. */
private newtype TExternalApi =
  MkExternalApi(string repr, DataFlowPrivate::ArgumentPosition apos) {
    exists(UntrustedExternalApiDataNode ex, InterestingExternalApiCall call |
      ex = call.getArgument(apos) and
      repr = call.getApiName()
    )
  }

/** A argument of an external API which is used with untrusted data. */
class ExternalApiUsedWithUntrustedData extends MkExternalApi {
  string repr;
  DataFlowPrivate::ArgumentPosition apos;

  ExternalApiUsedWithUntrustedData() { this = MkExternalApi(repr, apos) }

  /** Gets a possibly untrusted use of this external API. */
  UntrustedExternalApiDataNode getUntrustedDataNode() {
    exists(InterestingExternalApiCall call |
      result = call.getArgument(apos) and
      call.getApiName() = repr
    )
  }

  /** Gets the number of untrusted sources used with this external API. */
  int getNumberOfUntrustedSources() {
    result = count(this.getUntrustedDataNode().getAnUntrustedSource())
  }

  /** Gets a textual representation of this element. */
  string toString() { result = repr + " [" + apos + "]" }
}
