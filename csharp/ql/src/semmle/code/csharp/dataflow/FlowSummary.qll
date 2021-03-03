/**
 * Provides classes and predicates for definining flow summaries.
 */

import csharp
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch
// import all instances below
private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
private import semmle.code.csharp.frameworks.EntityFramework

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  import Impl::Public::SummaryComponent

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
}

class SummaryComponentStack = Impl::Public::SummaryComponentStack;

/** Provides predicates for constructing stacks of summary components. */
module SummaryComponentStack {
  import Impl::Public::SummaryComponentStack

  /** Gets a stack representing an element of `of`. */
  SummaryComponentStack elementOf(SummaryComponentStack of) {
    result = push(SummaryComponent::element(), of)
  }

  /** Gets a stack representing a propery `p` of `of`. */
  SummaryComponentStack propertyOf(Property p, SummaryComponentStack of) {
    result = push(SummaryComponent::property(p), of)
  }

  /** Gets a stack representing a field `f` of `of`. */
  SummaryComponentStack fieldOf(Field f, SummaryComponentStack of) {
    result = push(SummaryComponent::field(f), of)
  }

  /** Gets a singleton stack representing a (normal) return. */
  SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
}

class SummarizedCallable = Impl::Public::SummarizedCallable;

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;

private module ExternalSummaryCompilationExamples {
  private class SelectInputFlow extends Impl::Private::External::ExternalSummaryCompilation {
    SelectInputFlow() { this = "SelectInputFlow" }

    override predicate callable(DataFlowCallable c, boolean preservesValue) {
      c.getQualifiedName() = "System.Linq.Enumerable.Select" and
      preservesValue = true
    }

    override predicate input(int i, SummaryComponent comp) {
      i = 0 and
      comp = SummaryComponent::content(any(DataFlow::ElementContent ec))
      or
      i = 1 and
      comp = SummaryComponent::argument(0)
    }

    override predicate output(int i, SummaryComponent comp) {
      i = 0 and
      comp = SummaryComponent::parameter(0)
      or
      i = 1 and
      comp = SummaryComponent::argument(1)
    }
  }

  private class SelectOutputFlow extends Impl::Private::External::ExternalSummaryCompilation {
    SelectOutputFlow() { this = "SelectOutputFlow" }

    override predicate callable(DataFlowCallable c, boolean preservesValue) {
      c.getQualifiedName() = "System.Linq.Enumerable.Select" and
      preservesValue = true
    }

    override predicate input(int i, SummaryComponent comp) {
      i = 0 and
      comp = SummaryComponent::return()
      or
      i = 1 and
      comp = SummaryComponent::argument(1)
    }

    override predicate output(int i, SummaryComponent comp) {
      i = 0 and
      comp = SummaryComponent::element()
      or
      i = 1 and
      comp = SummaryComponent::return()
    }
  }
}
