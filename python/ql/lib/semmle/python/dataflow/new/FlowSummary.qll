/** Provides classes and predicates for defining flow summaries. */

import python
import semmle.python.dataflow.new.DataFlow
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowUtil
private import internal.DataFlowPrivate

// import all instances below
private module Summaries { }

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  private import Impl::Public::SummaryComponent as SC

  predicate parameter = SC::parameter/1;

  predicate argument = SC::argument/1;

  predicate content = SC::content/1;

  /** Gets a summary component that represents a list element. */
  SummaryComponent listElement() { result = content(any(ListElementContent c)) }

  /** Gets a summary component that represents the return value of a call. */
  SummaryComponent return() { result = SC::return(any(ReturnKind rk)) }
}

class SummaryComponentStack = Impl::Public::SummaryComponentStack;

/** Provides predicates for constructing stacks of summary components. */
module SummaryComponentStack {
  private import Impl::Public::SummaryComponentStack as SCS

  predicate singleton = SCS::singleton/1;

  predicate push = SCS::push/2;

  predicate argument = SCS::argument/1;

  /** Gets a singleton stack representing the return value of a call. */
  SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
}

/** A callable with a flow summary, identified by a unique string. */
abstract class SummarizedCallable extends LibraryCallable {
  bindingset[this]
  SummarizedCallable() { any() }

  /**
   * Holds if data may flow from `input` to `output` through this callable.
   *
   * `preservesValue` indicates whether this is a value-preserving step
   * or a taint-step.
   *
   * Input specifications are restricted to stacks that end with
   * `SummaryComponent::argument(_)`, preceded by zero or more
   * `SummaryComponent::return()` or `SummaryComponent::content(_)` components.
   *
   * Output specifications are restricted to stacks that end with
   * `SummaryComponent::return()` or `SummaryComponent::argument(_)`.
   *
   * Output stacks ending with `SummaryComponent::return()` can be preceded by zero
   * or more `SummaryComponent::content(_)` components.
   *
   * Output stacks ending with `SummaryComponent::argument(_)` can be preceded by an
   * optional `SummaryComponent::parameter(_)` component, which in turn can be preceded
   * by zero or more `SummaryComponent::content(_)` components.
   */
  pragma[nomagic]
  predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    none()
  }

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
   * Holds if values stored inside `content` are cleared on objects passed as
   * the `i`th argument to this callable.
   */
  pragma[nomagic]
  predicate clearsContent(int i, DataFlow::Content content) { none() }
}

private class SummarizedCallableAdapter extends Impl::Public::SummarizedCallable {
  private SummarizedCallable sc;

  SummarizedCallableAdapter() { this = TLibraryCallable(sc) }

  final override predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    sc.propagatesFlow(input, output, preservesValue)
  }

  final override predicate clearsContent(ParameterPosition pos, DataFlow::Content content) {
    sc.clearsContent(pos, content)
  }
}

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;
// private module ForTesting {
//   private class SummarizedCallableIdentity extends SummarizedCallable {
//     SummarizedCallableIdentity() { this = "identity" }
//     override Call getACall() { result.getFunc().(Name).getId() = this }
//     override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
//       input = "Argument[0]" and
//       output = "ReturnValue" and
//       preservesValue = true
//     }
//   }
//   // For lambda flow to work, implement lambdaCall and lambdaCreation
//   private class SummarizedCallableApplyLambda extends SummarizedCallable {
//     SummarizedCallableApplyLambda() { this = "apply_lambda" }
//     override Call getACall() { result.getFunc().(Name).getId() = this }
//     override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
//       input = "Argument[1]" and
//       output = "Parameter[0] of Argument[0]" and
//       preservesValue = true
//       or
//       input = "ReturnValue of Argument[0]" and
//       output = "ReturnValue" and
//       preservesValue = true
//     }
//   }
//   private class SummarizedCallableReversed extends SummarizedCallable {
//     SummarizedCallableReversed() { this = "reversed" }
//     override Call getACall() { result.getFunc().(Name).getId() = this }
//     override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
//       input = "ListElement of Argument[0]" and
//       output = "ListElement of ReturnValue" and
//       preservesValue = true
//     }
//   }
//   private class SummarizedCallableMap extends SummarizedCallable {
//     SummarizedCallableMap() { this = "map" }
//     override Call getACall() { result.getFunc().(Name).getId() = this }
//     override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
//       input = "ListElement of Argument[1]" and
//       output = "Parameter[0] of Argument[0]" and
//       preservesValue = true
//       or
//       input = "ReturnValue of Argument[0]" and
//       output = "ListElement of ReturnValue" and
//       preservesValue = true
//     }
//   }
//   // Typetracking needs to use a local flow step not including summaries
//   // Typetracking needs to use a call graph not including summaries
//   // private class SummarizedCallableJsonLoads extends SummarizedCallable {
//   //   SummarizedCallableJsonLoads() { this = "json.loads" }
//   //   override Call getACall() {
//   //     result = API::moduleImport("json").getMember("loads").getACall().asExpr()
//   //   }
//   //   override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
//   //     input = "Argument[0]" and
//   //     output = "ListElement of ReturnValue" and
//   //     preservesValue = true
//   //   }
//   // }
// }
