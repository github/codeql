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

  /**
   * Holds if data may flow from `input` to `output` through this callable.
   *
   * `preservesValue` indicates whether this is a value-preserving step or a taint-step.
   */
  pragma[nomagic]
  predicate propagatesFlow(string input, string output, boolean preservesValue) { none() }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    this.propagatesFlow(input, output, preservesValue) and model = this
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
