/** Provides classes and predicates for defining flow summaries. */

private import javascript
private import semmle.javascript.dataflow.internal.sharedlib.FlowSummaryImpl as Impl
private import semmle.javascript.dataflow.internal.FlowSummaryPrivate
private import semmle.javascript.dataflow.internal.sharedlib.DataFlowImplCommon as DataFlowImplCommon
private import semmle.javascript.dataflow.internal.DataFlowPrivate

/** A callable with a flow summary, identified by a unique string. */
abstract class SummarizedCallable extends LibraryCallable, Impl::Public::SummarizedCallable {
  bindingset[this]
  SummarizedCallable() { any() }

  // TODO: rename 'propagatesFlowExt' and/or override 'propagatesFlow' directly
  pragma[nomagic]
  predicate propagatesFlowExt(string input, string output, boolean preservesValue) { none() }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    this.propagatesFlowExt(input, output, preservesValue) and model = this
  }

  /**
   * Gets the synthesized parameter that results from an input specification
   * that starts with `Argument[s]` for this library callable.
   */
  DataFlow::ParameterNode getParameter(string s) {
    exists(ParameterPosition pos |
      DataFlowImplCommon::parameterNode(result, MkLibraryCallable(this), pos) and
      s = encodeParameterPosition(pos)
    )
  }
}
