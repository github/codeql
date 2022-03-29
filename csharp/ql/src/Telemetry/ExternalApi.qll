/** Provides classes and predicates related to handling APIs from external libraries. */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.dataflow.DataFlow
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.FlowSummary
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch
private import semmle.code.csharp.dataflow.TaintTracking
private import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
private import semmle.code.csharp.security.dataflow.flowsources.Remote

/**
 * A test library.
 */
class TestLibrary extends RefType {
  TestLibrary() {
    this.getNamespace()
        .getName()
        .matches(["NUnit.Framework%", "Xunit%", "Microsoft.VisualStudio.TestTools.UnitTesting%"])
  }
}

/**
 * An external API from either the C# Standard Library or a 3rd party library.
 */
class ExternalApi extends DataFlowDispatch::DataFlowCallable {
  ExternalApi() { this.fromLibrary() }

  /**
   * Gets the unbound type, name and parameter types of this API.
   */
  private string getSignature() {
    result =
      this.getDeclaringType().getUnboundDeclaration() + "." + this.getName() + "(" +
        parameterQualifiedTypeNamesToString(this) + ")"
  }

  /**
   * Gets the namespace of this API.
   */
  private string getNamespace() { this.getDeclaringType().hasQualifiedName(result, _) }

  /**
   * Gets the assembly file name containing this API.
   */
  private string getAssembly() { result = this.getFile().getBaseName() }

  /**
   * Gets the assembly file name and namespace of this API.
   */
  string getInfoPrefix() { result = this.getAssembly() + "#" + this.getNamespace() }

  /**
   * Gets the assembly file name, namespace and signature of this API.
   */
  string getInfo() { result = this.getInfoPrefix() + "#" + this.getSignature() }

  /** Gets a call to this API callable. */
  DispatchCall getACall() {
    this = result.getADynamicTarget().getUnboundDeclaration()
    or
    this = result.getAStaticTarget().getUnboundDeclaration()
  }

  /** Gets a node that is an input to a call to this API. */
  private ArgumentNode getAnInput() {
    result.getCall().(DataFlowDispatch::NonDelegateDataFlowCall).getDispatchCall() = this.getACall()
  }

  /** Gets a node that is an output from a call to this API. */
  private DataFlow::Node getAnOutput() {
    exists(DataFlowDispatch::NonDelegateDataFlowCall call, DataFlowImplCommon::ReturnKindExt ret |
      result = ret.getAnOutNode(call)
    |
      this.getACall() = call.getDispatchCall()
    )
  }

  /** Holds if this API has a supported summary. */
  predicate hasSummary() {
    this instanceof SummarizedCallable or
    defaultAdditionalTaintStep(this.getAnInput(), _)
  }

  /** Holds if this API is is a constructor without parameters. */
  private predicate isParameterlessConstructor() {
    this instanceof Constructor and this.getNumberOfParameters() = 0
  }

  /** Holds if this API is part of a common testing library or framework. */
  private predicate isTestLibrary() { this.getDeclaringType() instanceof TestLibrary }

  /** Holds if this API is not worth supporting. */
  predicate isUninteresting() { this.isTestLibrary() or this.isParameterlessConstructor() }

  /** Holds if this API is a known source. */
  predicate isSource() {
    this.getAnOutput() instanceof RemoteFlowSource or sourceNode(this.getAnOutput(), _)
  }

  /** Holds if this API is a known sink. */
  predicate isSink() { sinkNode(this.getAnInput(), _) }

  /** Holds if this API is supported by existing CodeQL libraries, that is, it is either a recognized source or sink or has a flow summary. */
  predicate isSupported() { this.hasSummary() or this.isSource() or this.isSink() }
}
