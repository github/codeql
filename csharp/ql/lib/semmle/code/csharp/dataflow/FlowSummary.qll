/** Provides classes and predicates for defining flow summaries. */

import csharp
private import dotnet
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch as DataFlowDispatch
private import Impl::Public::SummaryComponent as SummaryComponentInternal

class ParameterPosition = DataFlowDispatch::ParameterPosition;

class ArgumentPosition = DataFlowDispatch::ArgumentPosition;

// import all instances below
private module Summaries {
  private import semmle.code.csharp.frameworks.EntityFramework
}

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  predicate content = SummaryComponentInternal::content/1;

  /** Gets a summary component for parameter `i`. */
  SummaryComponent parameter(int i) {
    exists(ArgumentPosition pos |
      result = SummaryComponentInternal::parameter(pos) and
      i = pos.getPosition()
    )
  }

  /** Gets a summary component for argument `i`. */
  SummaryComponent argument(int i) {
    exists(ParameterPosition pos |
      result = SummaryComponentInternal::argument(pos) and
      i = pos.getPosition()
    )
  }

  predicate return = SummaryComponentInternal::return/1;

  /** Gets a summary component that represents a qualifier. */
  SummaryComponent qualifier() {
    exists(ParameterPosition pos |
      result = SummaryComponentInternal::argument(pos) and
      pos.isThisParameter()
    )
  }

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
  SummaryComponent return() { result = return(any(DataFlowDispatch::NormalReturnKind rk)) }

  predicate syntheticGlobal = SummaryComponentInternal::syntheticGlobal/1;

  class SyntheticGlobal = SummaryComponentInternal::SyntheticGlobal;
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

  /** Gets a stack representing an element of `container`. */
  SummaryComponentStack elementOf(SummaryComponentStack container) {
    result = push(SummaryComponent::element(), container)
  }

  /** Gets a stack representing a property `p` of `object`. */
  SummaryComponentStack propertyOf(Property p, SummaryComponentStack object) {
    result = push(SummaryComponent::property(p), object)
  }

  /** Gets a stack representing a field `f` of `object`. */
  SummaryComponentStack fieldOf(Field f, SummaryComponentStack object) {
    result = push(SummaryComponent::field(f), object)
  }

  /** Gets a singleton stack representing the return value of a call. */
  SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }

  /** Gets a singleton stack representing a synthetic global with name `name`. */
  SummaryComponentStack syntheticGlobal(string synthetic) {
    result = singleton(SummaryComponent::syntheticGlobal(synthetic))
  }

  /**
   * DEPRECATED: Use the member predicate `getMadRepresentation` instead.
   *
   * Gets a textual representation of this stack used for flow summaries.
   */
  deprecated string getComponentStack(SummaryComponentStack s) { result = s.getMadRepresentation() }
}

class SummarizedCallable = Impl::Public::SummarizedCallable;

private predicate recordConstructorFlow(Constructor c, int i, Property p) {
  c = any(RecordType r).getAMember() and
  exists(string name |
    c.getParameter(i).getName() = name and
    c.getDeclaringType().getAMember(name) = p
  )
}

private class RecordConstructorFlow extends SummarizedCallable {
  RecordConstructorFlow() { recordConstructorFlow(this, _, _) }

  override predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    exists(int i, Property p |
      recordConstructorFlow(this, i, p) and
      input = SummaryComponentStack::argument(i) and
      output = SummaryComponentStack::propertyOf(p, SummaryComponentStack::return()) and
      preservesValue = true
    )
  }
}

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;

private class RecordConstructorFlowRequiredSummaryComponentStack extends RequiredSummaryComponentStack
{
  override predicate required(SummaryComponent head, SummaryComponentStack tail) {
    exists(Property p |
      recordConstructorFlow(_, _, p) and
      head = SummaryComponent::property(p) and
      tail = SummaryComponentStack::return()
    )
  }
}

class Provenance = Impl::Public::Provenance;

private import semmle.code.csharp.frameworks.system.linq.Expressions

private SummaryComponent delegateSelf() {
  exists(ArgumentPosition pos |
    result = SummaryComponentInternal::parameter(pos) and
    pos.isDelegateSelf()
  )
}

private predicate mayInvokeCallback(Callable c, int n) {
  c.getParameter(n).getType() instanceof SystemLinqExpressions::DelegateExtType and
  not c.fromSource()
}

private class SummarizedCallableWithCallback extends SummarizedCallable {
  private int pos;

  SummarizedCallableWithCallback() { mayInvokeCallback(this, pos) }

  override predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    input = SummaryComponentStack::argument(pos) and
    output = SummaryComponentStack::push(delegateSelf(), input) and
    preservesValue = true
  }

  override predicate hasProvenance(Provenance provenance) { provenance = "hq-generated" }
}

private class RequiredComponentStackForCallback extends RequiredSummaryComponentStack {
  override predicate required(SummaryComponent head, SummaryComponentStack tail) {
    exists(int pos |
      mayInvokeCallback(_, pos) and
      head = delegateSelf() and
      tail = SummaryComponentStack::argument(pos)
    )
  }
}
