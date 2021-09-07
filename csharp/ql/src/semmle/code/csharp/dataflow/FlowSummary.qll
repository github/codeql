/** Provides classes and predicates for defining flow summaries. */

import csharp
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch

// import all instances below
private module Summaries {
  private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
  private import semmle.code.csharp.frameworks.EntityFramework
}

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  import Impl::Public::SummaryComponent

  /** Gets a summary component that represents a qualifier. */
  SummaryComponent qualifier() { result = argument(-1) }

  /** Gets a summary component that represents an element in a collection. */
  SummaryComponent element() { result = content(any(DataFlow::ElementContent c)) }

  /** Gets a summary component for property `p`. */
  SummaryComponent property(Property p) {
    result = content(any(DataFlow::PropertyContent c | c.getProperty() = p.getUnboundDeclaration()))
  }

  /** Gets a summary component for field `f`. */
  SummaryComponent field(Field f) {
    result = content(any(DataFlow::FieldContent c | c.getField() = f.getUnboundDeclaration()))
  }

  /** Gets a summary component that represents the return value of a call. */
  SummaryComponent return() { result = return(any(NormalReturnKind rk)) }

  /** Gets a summary component that represents a jump to `c`. */
  SummaryComponent jump(Callable c) {
    result =
      return(any(JumpReturnKind jrk |
          jrk.getTarget() = c.getUnboundDeclaration() and
          jrk.getTargetReturnKind() instanceof NormalReturnKind
        ))
  }
}

class SummaryComponentStack = Impl::Public::SummaryComponentStack;

/** Provides predicates for constructing stacks of summary components. */
module SummaryComponentStack {
  import Impl::Public::SummaryComponentStack

  /** Gets a singleton stack representing a qualifier. */
  SummaryComponentStack qualifier() { result = singleton(SummaryComponent::qualifier()) }

  /** Gets a stack representing an element of `container`. */
  SummaryComponentStack elementOf(SummaryComponentStack container) {
    result = push(SummaryComponent::element(), container)
  }

  /** Gets a stack representing a propery `p` of `object`. */
  SummaryComponentStack propertyOf(Property p, SummaryComponentStack object) {
    result = push(SummaryComponent::property(p), object)
  }

  /** Gets a stack representing a field `f` of `object`. */
  SummaryComponentStack fieldOf(Field f, SummaryComponentStack object) {
    result = push(SummaryComponent::field(f), object)
  }

  /** Gets a singleton stack representing the return value of a call. */
  SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }

  /** Gets a singleton stack representing a jump to `c`. */
  SummaryComponentStack jump(Callable c) { result = singleton(SummaryComponent::jump(c)) }
}

class SummarizedCallable = Impl::Public::SummarizedCallable;

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;
