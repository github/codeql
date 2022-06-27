/**
 * Provides classes and predicates for definining flow summaries.
 */

import go
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch
private import internal.DataFlowUtil

// import all instances below
private module Summaries { }

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  import Impl::Public::SummaryComponent

  /** Gets a summary component that represents a qualifier. */
  SummaryComponent qualifier() { result = argument(-1) }

  /** Gets a summary component for field `f`. */
  SummaryComponent field(Field f) { result = content(any(FieldContent c | c.getField() = f)) }

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

  /** Gets a singleton stack representing a (normal) return. */
  SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
}

class SummarizedCallable = Impl::Public::SummarizedCallable;

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;
