/** Provides classes and predicates for defining flow summaries. */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.ApiGraphs
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowUtil
private import internal.DataFlowPrivate

// import all instances below
private module Summaries {
  private import semmle.python.Frameworks
}

deprecated class SummaryComponent = Impl::Private::SummaryComponent;

/** Provides predicates for constructing summary components. */
deprecated module SummaryComponent = Impl::Private::SummaryComponent;

deprecated class SummaryComponentStack = Impl::Private::SummaryComponentStack;

deprecated module SummaryComponentStack = Impl::Private::SummaryComponentStack;

/** A callable with a flow summary, identified by a unique string. */
abstract class SummarizedCallable extends LibraryCallable, Impl::Public::SummarizedCallable {
  bindingset[this]
  SummarizedCallable() { any() }

  /**
   * DEPRECATED: Use `propagatesFlow` instead.
   */
  deprecated predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    this.propagatesFlow(input, output, preservesValue)
  }
}

deprecated class RequiredSummaryComponentStack = Impl::Private::RequiredSummaryComponentStack;

private module LibraryCallbackSummaries {
  private predicate libraryCall(CallCfgNode call) {
    not exists(NormalCall normalCall | call.getNode() = normalCall.getNode())
  }

  private DataFlow::LocalSourceNode trackLambdaCreation(TypeTracker t) {
    t.start() and
    lambdaCreation(result, _, _)
    or
    exists(TypeTracker t2 | result = trackLambdaCreation(t2).track(t2, t)) and
    not result.(ParameterNode).getParameter().isSelf()
  }

  private predicate libraryCallHasLambdaArg(CallCfgNode call, int i) {
    exists(CfgNode arg |
      arg = call.getArg(i) and
      arg.getALocalSource() = trackLambdaCreation(TypeTracker::end()) and
      libraryCall(call)
    )
  }

  private class LibraryLambdaMethod extends SummarizedCallable {
    LibraryLambdaMethod() { this = "<library method accepting a callback>" }

    final override CallCfgNode getACall() { libraryCallHasLambdaArg(result, _) }

    final override ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(int i |
        i in [0 .. 10] and
        input = "Argument[" + i + "]" and
        output = "Argument[" + i + "].Parameter[lambda-self]"
      ) and
      preservesValue = true
    }
  }
}

private class SummarizedCallableFromModel extends SummarizedCallable {
  string type;
  string path;

  SummarizedCallableFromModel() {
    ModelOutput::relevantSummaryModel(type, path, _, _, _) and
    this = type + ";" + path
  }

  override CallCfgNode getACall() { ModelOutput::resolvedSummaryBase(type, path, result) }

  override ArgumentNode getACallback() {
    exists(API::Node base |
      ModelOutput::resolvedSummaryRefBase(type, path, base) and
      result = base.getAValueReachableFromSource()
    )
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    exists(string kind | ModelOutput::relevantSummaryModel(type, path, input, output, kind) |
      kind = "value" and
      preservesValue = true
      or
      kind = "taint" and
      preservesValue = false
    )
  }
}
