/**
 * Provides classes and predicates for definining flow summaries.
 */

import python
private import new.internal.FlowSummaryImpl as Impl
// private import internal.DataFlowDispatch
private import new.internal.DataFlowUtil

// import all instances of SummarizedCallable below
private module Summaries {
  private import ExternalFlow
}

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  import Impl::Public::SummaryComponent

  /** Gets a summary component for field `f`. */
  SummaryComponent attribute(string attr) {
    result = content(any(AttributeContent c | c.getAttribute() = attr))
  }

  /** Gets a summary component that represents the return value of a call. */
  SummaryComponent return() { result = return(_) }
}

class SummaryComponentStack = Impl::Public::SummaryComponentStack;

/** Provides predicates for constructing stacks of summary components. */
module SummaryComponentStack {
  import Impl::Public::SummaryComponentStack

  /** Gets a stack representing a field `f` of `object`. */
  SummaryComponentStack attributeOf(string attr, SummaryComponentStack object) {
    result = push(SummaryComponent::attribute(attr), object)
  }

  /** Gets a singleton stack representing a (normal) return. */
  SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
}

class SummarizedCallable = Impl::Public::SummarizedCallable;

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;
