/** Provides classes and predicates for defining flow summaries. */

import swift
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch as DataFlowDispatch

class ParameterPosition = DataFlowDispatch::ParameterPosition;

class ArgumentPosition = DataFlowDispatch::ArgumentPosition;

// import all instances below
private module Summaries {
  /* TODO */
}

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  private import Impl::Public::SummaryComponent as SummaryComponentInternal

  predicate content = SummaryComponentInternal::content/1;

  /** Gets a summary component for parameter `i`. */
  SummaryComponent parameter(int i) {
    none() // TODO
  }

  /** Gets a summary component for argument `i`. */
  SummaryComponent argument(int i) {
    none() // TODO
  }

  predicate return = SummaryComponentInternal::return/1;

  /** Gets a summary component that represents a qualifier. */
  SummaryComponent qualifier() {
    none() // TODO
  }

  /** Gets a summary component that represents the return value of a call. */
  SummaryComponent return() { result = return(any(DataFlowDispatch::NormalReturnKind rk)) }
}

class SummaryComponentStack = Impl::Public::SummaryComponentStack;

/** Provides predicates for constructing stacks of summary components. */
module SummaryComponentStack {
  private import Impl::Public::SummaryComponentStack as SummaryComponentStackInternal

  predicate singleton = SummaryComponentStackInternal::singleton/1;

  predicate push = SummaryComponentStackInternal::push/2;

  /** Gets a singleton stack for argument `i`. */
  SummaryComponentStack argument(int i) { result = singleton(SummaryComponent::argument(i)) }

  predicate return = SummaryComponentStackInternal::return/1;

  /** Gets a singleton stack representing a qualifier. */
  SummaryComponentStack qualifier() { result = singleton(SummaryComponent::qualifier()) }

  /** Gets a singleton stack representing the return value of a call. */
  SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
}

class SummarizedCallable = Impl::Public::SummarizedCallable;

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;
