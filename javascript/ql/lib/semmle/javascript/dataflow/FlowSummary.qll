/** Provides classes and predicates for defining flow summaries. */

private import javascript
private import semmle.javascript.dataflow.internal.sharedlib.FlowSummaryImpl as Impl
private import semmle.javascript.dataflow.internal.sharedlib.FlowSummaryImplSpecific
private import semmle.javascript.dataflow.internal.sharedlib.DataFlowImplCommon as DataFlowImplCommon
private import semmle.javascript.dataflow.internal.DataFlowPrivate

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  private import Impl::Public::SummaryComponent as SC

  predicate parameter = SC::parameter/1;

  predicate argument = SC::argument/1;

  predicate content = SC::content/1;

  predicate withoutContent = SC::withoutContent/1;

  predicate withContent = SC::withContent/1;

  class SyntheticGlobal = SC::SyntheticGlobal;

  /** Gets a summary component that represents a receiver. */
  SummaryComponent receiver() { result = argument(MkThisParameter()) }

  /** Gets a summary component that represents the return value of a call. */
  SummaryComponent return() { result = SC::return(MkNormalReturnKind()) }

  /** Gets a summary component that represents the exception thrown from a call. */
  SummaryComponent exceptionalReturn() { result = SC::return(MkExceptionalReturnKind()) }
}

class SummaryComponentStack = Impl::Public::SummaryComponentStack;

/** Provides predicates for constructing stacks of summary components. */
module SummaryComponentStack {
  private import Impl::Public::SummaryComponentStack as SCS

  predicate singleton = SCS::singleton/1;

  predicate push = SCS::push/2;

  predicate argument = SCS::argument/1;

  /** Gets a singleton stack representing a receiver. */
  SummaryComponentStack receiver() { result = singleton(SummaryComponent::receiver()) }

  /** Gets a singleton stack representing the return value of a call. */
  SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }

  /** Gets a singleton stack representing the exception thrown from a call. */
  SummaryComponentStack exceptionalReturn() {
    result = singleton(SummaryComponent::exceptionalReturn())
  }
}

/** A callable with a flow summary, identified by a unique string. */
abstract class SummarizedCallable extends LibraryCallable, Impl::Public::SummarizedCallable {
  bindingset[this]
  SummarizedCallable() { any() }

  /**
   * Same as
   *
   * ```ql
   * propagatesFlow(
   *   SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
   * )
   * ```
   *
   * but uses an external (string) representation of the input and output stacks.
   */
  pragma[nomagic]
  predicate propagatesFlowExt(string input, string output, boolean preservesValue) { none() }

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

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;
