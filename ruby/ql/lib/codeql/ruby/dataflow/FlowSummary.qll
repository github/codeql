/** Provides classes and predicates for defining flow summaries. */

import ruby
import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.data.ModelsAsData
private import codeql.ruby.ApiGraphs
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch
private import internal.DataFlowPrivate

// import all instances below
private module Summaries {
  private import codeql.ruby.Frameworks
}

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  private import Impl::Public::SummaryComponent as SC

  predicate parameter = SC::parameter/1;

  predicate argument = SC::argument/1;

  predicate content = SC::content/1;

  /** Gets a summary component that represents a receiver. */
  SummaryComponent receiver() { result = argument(any(ParameterPosition pos | pos.isSelf())) }

  /** Gets a summary component that represents a block argument. */
  SummaryComponent block() { result = argument(any(ParameterPosition pos | pos.isBlock())) }

  /** Gets a summary component that represents an element in an array at an unknown index. */
  SummaryComponent arrayElementUnknown() {
    result = SC::content(TSingletonContent(TUnknownArrayElementContent()))
  }

  /**
   * Gets a summary component that represents an element in an array at a known index.
   *
   * Has no result for negative indices. Wrap-around interpretation of negative indices should be
   * handled by the caller, if modeling a function that has such behavior.
   */
  bindingset[i]
  SummaryComponent arrayElementKnown(int i) {
    result = SC::content(TSingletonContent(TKnownArrayElementContent(i)))
    or
    // `i` may be out of range
    i >= 0 and
    not exists(TKnownArrayElementContent(i)) and
    result = arrayElementUnknown()
  }

  /**
   * Gets a summary component that represents an element in an array at either an unknown
   * index or known index. This predicate should never be used in the output specification
   * of a flow summary; use `arrayElementUnknown()` instead.
   */
  SummaryComponent arrayElementAny() { result = SC::content(TAnyArrayElementContent()) }

  /** Gets a summary component that represents the return value of a call. */
  SummaryComponent return() { result = SC::return(any(NormalReturnKind rk)) }
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

  /** Gets a singleton stack representing a block argument. */
  SummaryComponentStack block() { result = singleton(SummaryComponent::block()) }

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
   * arguments at position `pos` to this callable.
   */
  pragma[nomagic]
  predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) { none() }
}

/**
 * A callable with a flow summary, identified by a unique string, where all
 * calls to a method with the same name are considered relevant.
 */
abstract class SimpleSummarizedCallable extends SummarizedCallable {
  MethodCall mc;

  bindingset[this]
  SimpleSummarizedCallable() { mc.getMethodName() = this }

  final override MethodCall getACall() { result = mc }
}

private class SummarizedCallableAdapter extends Impl::Public::SummarizedCallable {
  private SummarizedCallable sc;

  SummarizedCallableAdapter() { this = TLibraryCallable(sc) }

  final override predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    sc.propagatesFlow(input, output, preservesValue)
  }

  final override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
    sc.clearsContent(pos, content)
  }
}

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;

private class SummarizedCallableFromModel extends SummarizedCallable {
  string package;
  string type;
  string path;

  SummarizedCallableFromModel() {
    ModelOutput::relevantSummaryModel(package, type, path, _, _, _) and
    this = package + ";" + type + ";" + path
  }

  override Call getACall() {
    exists(API::MethodAccessNode base |
      ModelOutput::resolvedSummaryBase(package, type, path, base) and
      result = base.getCallNode().asExpr().getExpr()
    )
  }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    exists(string kind |
      ModelOutput::relevantSummaryModel(package, type, path, input, output, kind)
    |
      kind = "value" and
      preservesValue = true
      or
      kind = "taint" and
      preservesValue = false
    )
  }
}
