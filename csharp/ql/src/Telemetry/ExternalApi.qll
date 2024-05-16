/** Provides classes and predicates related to handling APIs from external libraries. */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.dataflow.FlowSummary
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
private import semmle.code.csharp.security.dataflow.flowsources.ApiSources as ApiSources
private import semmle.code.csharp.security.dataflow.flowsinks.ApiSinks as ApiSinks
private import TestLibrary

/** Holds if the given callable is not worth supporting. */
private predicate isUninteresting(Callable c) {
  c.getDeclaringType() instanceof TestLibrary
  or
  c.(Constructor).isParameterless()
  or
  // The data flow library uses read/store steps for properties, so we don't need to model them,
  // if both a getter and a setter exist.
  c.(Accessor).getDeclaration().(Property).isReadWrite()
}

/**
 * An external API from either the C# Standard Library or a 3rd party library.
 */
class ExternalApi extends Callable {
  ExternalApi() {
    this.isUnboundDeclaration() and
    this.fromLibrary() and
    this.(Modifiable).isEffectivelyPublic() and
    not isUninteresting(this)
  }

  /**
   * Gets the unbound type, name and parameter types of this API.
   */
  bindingset[this]
  private string getSignature() {
    result =
      nestedName(this.getDeclaringType().getUnboundDeclaration()) + "." + this.getName() + "(" +
        parameterQualifiedTypeNamesToString(this) + ")"
  }

  /**
   * Gets the namespace of this API.
   */
  bindingset[this]
  string getNamespace() { this.getDeclaringType().hasFullyQualifiedName(result, _) }

  /**
   * Gets the namespace and signature of this API.
   */
  bindingset[this]
  string getApiName() { result = this.getNamespace() + "#" + this.getSignature() }

  /** Gets a node that is an input to a call to this API. */
  private ArgumentNode getAnInput() {
    result
        .getCall()
        .(DataFlowDispatch::NonDelegateDataFlowCall)
        .getATarget(_)
        .getUnboundDeclaration() = this
  }

  /** Gets a node that is an output from a call to this API. */
  private DataFlow::Node getAnOutput() {
    exists(Call c, DataFlowDispatch::NonDelegateDataFlowCall dc |
      dc.getDispatchCall().getCall() = c and
      c.getTarget().getUnboundDeclaration() = this
    |
      result = DataFlowDispatch::getAnOutNode(dc, _)
    )
  }

  /** Holds if this API has a supported summary. */
  pragma[nomagic]
  predicate hasSummary() {
    this instanceof SummarizedCallable
    or
    defaultAdditionalTaintStep(this.getAnInput(), _, _)
  }

  /** Holds if this API is a known source. */
  pragma[nomagic]
  predicate isSource() { this.getAnOutput() instanceof ApiSources::SourceNode }

  /** Holds if this API is a known sink. */
  pragma[nomagic]
  predicate isSink() { this.getAnInput() instanceof ApiSinks::SinkNode }

  /** Holds if this API is a known neutral. */
  pragma[nomagic]
  predicate isNeutral() { this instanceof FlowSummaryImpl::Public::NeutralCallable }

  /**
   * Holds if this API is supported by existing CodeQL libraries, that is, it is either a
   * recognized source, sink or neutral or it has a flow summary.
   */
  predicate isSupported() {
    this.hasSummary() or this.isSource() or this.isSink() or this.isNeutral()
  }
}

/**
 * Gets the nested name of the type `t`.
 *
 * If the type is not a nested type, the result is the same as \`getName()\`.
 * Otherwise the name of the nested type is prefixed with a \`+\` and appended to
 * the name of the enclosing type, which might be a nested type as well.
 */
private string nestedName(Type t) {
  not exists(t.getDeclaringType().getUnboundDeclaration()) and
  result = t.getName()
  or
  nestedName(t.getDeclaringType().getUnboundDeclaration()) + "+" + t.getName() = result
}

/**
 * Gets the limit for the number of results produced by a telemetry query.
 */
int resultLimit() { result = 100 }

/**
 * Holds if it is relevant to count usages of `api`.
 */
signature predicate relevantApi(ExternalApi api);

/**
 * Given a predicate to count relevant API usages, this module provides a predicate
 * for restricting the number or returned results based on a certain limit.
 */
module Results<relevantApi/1 getRelevantUsages> {
  private int getUsages(string apiName) {
    result =
      strictcount(Call c, ExternalApi api |
        c.getTarget().getUnboundDeclaration() = api and
        apiName = api.getApiName() and
        getRelevantUsages(api) and
        c.fromSource()
      )
  }

  private int getOrder(string apiName) {
    apiName =
      rank[result](string name, int usages |
        usages = getUsages(name)
      |
        name order by usages desc, name
      )
  }

  /**
   * Holds if there exists an API with `apiName` that is being used `usages` times
   * and if it is in the top results (guarded by resultLimit).
   */
  predicate restrict(string apiName, int usages) {
    usages = getUsages(apiName) and
    getOrder(apiName) <= resultLimit()
  }
}
