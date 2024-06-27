/**
 * Provides classes and predicates for defining flow summaries.
 */

import java
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowUtil

deprecated class SummaryComponent = Impl::Private::SummaryComponent;

deprecated module SummaryComponent = Impl::Private::SummaryComponent;

deprecated class SummaryComponentStack = Impl::Private::SummaryComponentStack;

deprecated module SummaryComponentStack = Impl::Private::SummaryComponentStack;

/** A synthetic callable with a set of concrete call sites and a flow summary. */
abstract class SyntheticCallable extends string {
  bindingset[this]
  SyntheticCallable() { any() }

  /** Gets a call that targets this callable. */
  abstract Call getACall();

  /**
   * Holds if data may flow from `input` to `output` through this callable.
   *
   * See `SummarizedCallable::propagatesFlow` for details.
   */
  abstract predicate propagatesFlow(string input, string output, boolean preservesValue);

  /**
   * Gets the type of the parameter at the specified position with -1 indicating
   * the instance parameter. If no types are provided then the types default to
   * `Object`.
   */
  Type getParameterType(int pos) { none() }

  /**
   * Gets the return type of this callable. If no type is provided then the type
   * defaults to `Object`.
   */
  Type getReturnType() { none() }
}

/**
 * A module for importing frameworks that define synthetic callables.
 */
private module SyntheticCallables {
  private import semmle.code.java.dispatch.WrappedInvocation
  private import semmle.code.java.frameworks.android.Intent
  private import semmle.code.java.frameworks.Stream
}

private newtype TSummarizedCallableBase =
  TSimpleCallable(Callable c) { c.isSourceDeclaration() } or
  TSyntheticCallable(SyntheticCallable c)

/**
 * A callable that may have a flow summary. This is either a regular `Callable`
 * or a `SyntheticCallable`.
 */
class SummarizedCallableBase extends TSummarizedCallableBase {
  /** Gets a textual representation of this callable. */
  string toString() { result = this.asCallable().toString() or result = this.asSyntheticCallable() }

  /** Gets the source location for this callable. */
  Location getLocation() {
    result = this.asCallable().getLocation()
    or
    result.hasLocationInfo("", 0, 0, 0, 0) and
    this instanceof TSyntheticCallable
  }

  /** Gets this callable cast as a `Callable`. */
  Callable asCallable() { this = TSimpleCallable(result) }

  /** Gets this callable cast as a `SyntheticCallable`. */
  SyntheticCallable asSyntheticCallable() { this = TSyntheticCallable(result) }

  /** Gets a call that targets this callable. */
  Call getACall() {
    result.getCallee().getSourceDeclaration() = this.asCallable()
    or
    result = this.asSyntheticCallable().getACall()
  }

  /**
   * Gets the type of the parameter at the specified position with -1 indicating
   * the instance parameter.
   */
  Type getParameterType(int pos) {
    result = this.asCallable().getParameterType(pos)
    or
    pos = -1 and result = this.asCallable().getDeclaringType()
    or
    result = this.asSyntheticCallable().getParameterType(pos)
    or
    exists(SyntheticCallable sc, Impl::Private::SummaryNode p | sc = this.asSyntheticCallable() |
      Impl::Private::summaryParameterNode(p, pos) and
      this = p.getSummarizedCallable() and
      not exists(sc.getParameterType(pos)) and
      result instanceof TypeObject
    )
  }

  /** Gets the return type of this callable. */
  Type getReturnType() {
    result = this.asCallable().getReturnType()
    or
    exists(SyntheticCallable sc | sc = this.asSyntheticCallable() |
      result = sc.getReturnType()
      or
      not exists(sc.getReturnType()) and
      result instanceof TypeObject
    )
  }
}

class Provenance = Impl::Public::Provenance;

class SummarizedCallable = Impl::Public::SummarizedCallable;

/**
 * An adapter class to add the flow summaries specified on `SyntheticCallable`
 * to `SummarizedCallable`.
 */
private class SummarizedSyntheticCallableAdapter extends SummarizedCallable, TSyntheticCallable {
  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    exists(SyntheticCallable sc |
      sc = this.asSyntheticCallable() and
      sc.propagatesFlow(input, output, preservesValue) and
      model = sc
    )
  }

  override predicate hasExactModel() { any() }
}

deprecated class RequiredSummaryComponentStack = Impl::Private::RequiredSummaryComponentStack;
