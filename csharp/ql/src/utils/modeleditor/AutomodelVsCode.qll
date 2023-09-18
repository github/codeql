/** Provides classes and predicates related to handling APIs for the VS Code extension. */

private import csharp
private import dotnet
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.FlowSummary
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
private import semmle.code.csharp.frameworks.Test
private import semmle.code.csharp.security.dataflow.flowsources.Remote

private import Telemetry.TestLibrary

/** Holds if the given callable is not worth supporting. */
private predicate isUninteresting(DotNet::Declaration c) {
  c.getDeclaringType() instanceof TestLibrary or
  c.(Constructor).isParameterless() or
  c.getDeclaringType() instanceof AnonymousClass
}

/**
 * An callable method from either the C# Standard Library, a 3rd party library, or from the source.
 */
class CallableMethod extends DotNet::Declaration {
  CallableMethod() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic() and
    not isUninteresting(this)
  }

  /**
   * Gets the unbound type, name and parameter types of this API.
   */
  bindingset[this]
  private string getSignature() {
    result =
      nestedName(this.getDeclaringType().getUnboundDeclaration()) + "#" + this.getName() + "(" +
        parameterQualifiedTypeNamesToString(this) + ")"
  }

  /**
   * Gets the namespace of this API.
   */
  bindingset[this]
  string getNamespace() { this.getDeclaringType().hasQualifiedName(result, _) }

  /**
   * Gets the namespace and signature of this API.
   */
  bindingset[this]
  string getApiName() { result = this.getNamespace() + "." + this.getSignature() }

  private string getDllName() { result = this.getLocation().(Assembly).getName() }

  private string getDllVersion() { result = this.getLocation().(Assembly).getVersion().toString() }

  string dllName() {
    result = this.getDllName()
    or
    not exists(this.getDllName()) and result = this.getFile().getBaseName()
  }

  string dllVersion() {
    result = this.getDllVersion()
    or
    not exists(this.getDllVersion()) and result = ""
  }

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
    exists(
      Call c, DataFlowDispatch::NonDelegateDataFlowCall dc, DataFlowImplCommon::ReturnKindExt ret
    |
      dc.getDispatchCall().getCall() = c and
      c.getTarget().getUnboundDeclaration() = this
    |
      result = ret.getAnOutNode(dc)
    )
  }

  /** Holds if this API has a supported summary. */
  pragma[nomagic]
  predicate hasSummary() {
    this instanceof SummarizedCallable
    or
    defaultAdditionalTaintStep(this.getAnInput(), _)
  }

  /** Holds if this API is a known source. */
  pragma[nomagic]
  predicate isSource() {
    this.getAnOutput() instanceof RemoteFlowSource or sourceNode(this.getAnOutput(), _)
  }

  /** Holds if this API is a known sink. */
  pragma[nomagic]
  predicate isSink() { sinkNode(this.getAnInput(), _) }

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

boolean isSupported(CallableMethod callableMethod) {
  callableMethod.isSupported() and result = true
  or
  not callableMethod.isSupported() and
  result = false
}

string supportedType(CallableMethod method) {
  method.isSink() and result = "sink"
  or
  method.isSource() and result = "source"
  or
  method.hasSummary() and result = "summary"
  or
  method.isNeutral() and result = "neutral"
  or
  not method.isSupported() and result = ""
}

string methodClassification(Call method) {
  method.getFile() instanceof TestFile and result = "test"
  or
  not method.getFile() instanceof TestFile and
  result = "source"
}

/**
 * Gets the nested name of the declaration.
 *
 * If the declaration is not a nested type, the result is the same as `getName()`.
 * Otherwise the name of the nested type is prefixed with a `+` and appended to
 * the name of the enclosing type, which might be a nested type as well.
 */
private string nestedName(Declaration declaration) {
  not exists(declaration.getDeclaringType().getUnboundDeclaration()) and
  result = declaration.getName()
  or
  nestedName(declaration.getDeclaringType().getUnboundDeclaration()) + "+" + declaration.getName() =
    result
}
