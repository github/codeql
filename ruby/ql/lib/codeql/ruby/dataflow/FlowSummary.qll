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

  predicate withoutContent = SC::withoutContent/1;

  predicate withContent = SC::withContent/1;

  /** Gets a summary component that represents a receiver. */
  SummaryComponent receiver() { result = argument(any(ParameterPosition pos | pos.isSelf())) }

  /** Gets a summary component that represents a block argument. */
  SummaryComponent block() { result = argument(any(ParameterPosition pos | pos.isBlock())) }

  /** Gets a summary component that represents an element in a collection at an unknown index. */
  SummaryComponent elementUnknown() {
    result = SC::content(TSingletonContent(TUnknownElementContent()))
  }

  /** Gets a summary component that represents an element in a collection at a known index. */
  SummaryComponent elementKnown(ConstantValue cv) {
    result = SC::content(TSingletonContent(DataFlow::Content::getElementContent(cv)))
  }

  /**
   * Gets a summary component that represents an element in a collection at either an unknown
   * index or known index. This has the same semantics as
   *
   * ```ql
   * elementKnown() or elementUnknown(_)
   * ```
   *
   * but is more efficient, because it is represented by a single value.
   */
  SummaryComponent elementAny() { result = SC::content(TAnyElementContent()) }

  /**
   * Gets a summary component that represents an element in a collection at known
   * integer index `lower` or above.
   */
  SummaryComponent elementLowerBound(int lower) {
    result = SC::content(TElementLowerBoundContent(lower))
  }

  /** Gets a summary component that represents a value in a pair at an unknown key. */
  SummaryComponent pairValueUnknown() {
    result = SC::content(TSingletonContent(TUnknownPairValueContent()))
  }

  /** Gets a summary component that represents a value in a pair at a known key. */
  SummaryComponent pairValueKnown(ConstantValue key) {
    result = SC::content(TSingletonContent(TKnownPairValueContent(key)))
  }

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
