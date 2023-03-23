/**
 * Provides classes and predicates for defining flow summaries.
 */

import java
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowUtil

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  import Impl::Public::SummaryComponent

  /** Gets a summary component that represents a qualifier. */
  SummaryComponent qualifier() { result = argument(-1) }

  /** Gets a summary component for field `f`. */
  SummaryComponent field(Field f) { result = content(any(FieldContent c | c.getField() = f)) }

  /** Gets a summary component for `Element`. */
  SummaryComponent element() { result = content(any(CollectionContent c)) }

  /** Gets a summary component for `ArrayElement`. */
  SummaryComponent arrayElement() { result = content(any(ArrayContent c)) }

  /** Gets a summary component for `MapValue`. */
  SummaryComponent mapValue() { result = content(any(MapValueContent c)) }

  /** Gets a summary component that represents the return value of a call. */
  SummaryComponent return() { result = return(_) }
}

class SummaryComponentStack = Impl::Public::SummaryComponentStack;

/** Provides predicates for constructing stacks of summary components. */
module SummaryComponentStack {
  import Impl::Public::SummaryComponentStack

  /** Gets a singleton stack representing a qualifier. */
  SummaryComponentStack qualifier() { result = singleton(SummaryComponent::qualifier()) }

  /** Gets a stack representing a field `f` of `object`. */
  SummaryComponentStack fieldOf(Field f, SummaryComponentStack object) {
    result = push(SummaryComponent::field(f), object)
  }

  /** Gets a stack representing `Element` of `object`. */
  SummaryComponentStack elementOf(SummaryComponentStack object) {
    result = push(SummaryComponent::element(), object)
  }

  /** Gets a stack representing `ArrayElement` of `object`. */
  SummaryComponentStack arrayElementOf(SummaryComponentStack object) {
    result = push(SummaryComponent::arrayElement(), object)
  }

  /** Gets a stack representing `MapValue` of `object`. */
  SummaryComponentStack mapValueOf(SummaryComponentStack object) {
    result = push(SummaryComponent::mapValue(), object)
  }

  /** Gets a singleton stack representing a (normal) return. */
  SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
}

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
  predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    none()
  }

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
    exists(SyntheticCallable sc | sc = this.asSyntheticCallable() |
      Impl::Private::summaryParameterNodeRange(this, pos) and
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

class SummarizedCallable = Impl::Public::SummarizedCallable;

class NeutralCallable = Impl::Public::NeutralCallable;

/**
 * An adapter class to add the flow summaries specified on `SyntheticCallable`
 * to `SummarizedCallable`.
 */
private class SummarizedSyntheticCallableAdapter extends SummarizedCallable, TSyntheticCallable {
  override predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    this.asSyntheticCallable().propagatesFlow(input, output, preservesValue)
  }
}

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;
