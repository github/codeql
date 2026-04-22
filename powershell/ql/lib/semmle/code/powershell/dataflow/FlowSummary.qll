/** Provides classes and predicates for defining flow summaries. */

import powershell
private import semmle.code.powershell.controlflow.Cfg
private import semmle.code.powershell.typetracking.TypeTracking
private import semmle.code.powershell.dataflow.DataFlow
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch
private import internal.DataFlowImplCommon as DataFlowImplCommon
private import internal.DataFlowPrivate

// import all instances below
private module Summaries {
  private import semmle.code.powershell.Frameworks
  private import semmle.code.powershell.frameworks.data.ModelsAsData
  import RunspaceFactory
  import PowerShell
  import EngineIntrinsics
}

class Provenance = Impl::Public::Provenance;

/** Provides the `Range` class used to define the extent of `SummarizedCallable`. */
module SummarizedCallable {
  /** A callable with a flow summary, identified by a unique string. */
  abstract class Range extends LibraryCallable, Impl::Public::SummarizedCallable {
    bindingset[this]
    Range() { any() }

    override predicate propagatesFlow(
      string input, string output, boolean preservesValue, Provenance p, boolean isExact,
      string model
    ) {
      this.propagatesFlow(input, output, preservesValue) and
      p = "manual" and
      isExact = true and
      model = ""
    }

    /**
     * Holds if data may flow from `input` to `output` through this callable.
     *
     * `preservesValue` indicates whether this is a value-preserving step or a taint-step.
     */
    predicate propagatesFlow(string input, string output, boolean preservesValue) { none() }

    /**
     * Gets the synthesized parameter that results from an input specification
     * that starts with `Argument[s]` for this library callable.
     */
    DataFlow::ParameterNode getParameter(string s) {
      exists(ParameterPosition pos |
        DataFlowImplCommon::parameterNode(result, TLibraryCallable(this), pos) and
        s = Impl::Input::encodeParameterPosition(pos)
      )
    }
  }
}

final private class SummarizedCallableFinal = SummarizedCallable::Range;

/** A callable with a flow summary, identified by a unique string. */
final class SummarizedCallable extends SummarizedCallableFinal,
  Impl::Public::RelevantSummarizedCallable
{ }
