/**
 * Provides C# specific classes and predicates for definining flow summaries.
 */

private import csharp
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import DataFlowDispatch

module Private {
  private import Public
  private import DataFlowPrivate as DataFlowPrivate
  private import DataFlowPublic as DataFlowPublic
  private import FlowSummaryImpl as Impl
  private import semmle.code.csharp.Unification

  class Content = DataFlowPublic::Content;

  class DataFlowType = DataFlowPrivate::DataFlowType;

  class Node = DataFlowPublic::Node;

  class ParameterNode = DataFlowPublic::ParameterNode;

  class ArgumentNode = DataFlowPrivate::ArgumentNode;

  class ReturnNode = DataFlowPrivate::ReturnNode;

  class OutNode = DataFlowPrivate::OutNode;

  private class NodeImpl = DataFlowPrivate::NodeImpl;

  predicate accessPathLimit = DataFlowPrivate::accessPathLimit/0;

  predicate hasDelegateArgumentPosition(SummarizableCallable c, int i) {
    exists(DelegateType dt |
      dt = c.getParameter(i).getType().(SystemLinqExpressions::DelegateExtType).getDelegateType()
    |
      not dt.getReturnType() instanceof VoidType
    )
  }

  predicate hasDelegateArgumentPosition2(SummarizableCallable c, int i, int j) {
    exists(DelegateType dt |
      dt = c.getParameter(i).getType().(SystemLinqExpressions::DelegateExtType).getDelegateType()
    |
      exists(dt.getParameter(j))
    )
  }

  newtype TSummaryInput =
    TParameterSummaryInput(int i) { i in [-1, any(Parameter p).getPosition()] } or
    TDelegateSummaryInput(int i) { hasDelegateArgumentPosition(_, i) }

  newtype TSummaryOutput =
    TReturnSummaryOutput() or
    TParameterSummaryOutput(int i) {
      i in [-1, any(SummarizableCallable c).getAParameter().getPosition()]
    } or
    TDelegateSummaryOutput(int i, int j) { hasDelegateArgumentPosition2(_, i, j) } or
    TJumpSummaryOutput(SummarizableCallable target, ReturnKind rk) {
      rk instanceof NormalReturnKind and
      (
        target instanceof Constructor or
        not target.getReturnType() instanceof VoidType
      )
      or
      rk instanceof QualifierReturnKind and
      not target.(Modifiable).isStatic()
      or
      exists(target.getParameter(rk.(OutRefReturnKind).getPosition()))
    }

  /** Gets the return kind that matches `sink`, if any. */
  ReturnKind toReturnKind(SummaryOutput output) {
    output = TReturnSummaryOutput() and
    result instanceof NormalReturnKind
    or
    exists(int i | output = TParameterSummaryOutput(i) |
      i = -1 and
      result instanceof QualifierReturnKind
      or
      i = result.(OutRefReturnKind).getPosition()
    )
  }

  /** Gets the input node for `c` of type `input`. */
  NodeImpl inputNode(SummarizableCallable c, SummaryInput input) {
    exists(int i |
      input = TParameterSummaryInput(i) and
      result = DataFlowPrivate::TSummaryParameterNode(c, i)
    )
    or
    exists(int i |
      input = TDelegateSummaryInput(i) and
      result = DataFlowPrivate::TSummaryDelegateOutNode(c, i)
    )
  }

  /** Gets the output node for `c` of type `output`. */
  NodeImpl outputNode(SummarizableCallable c, SummaryOutput output) {
    result = DataFlowPrivate::TSummaryReturnNode(c, toReturnKind(output))
    or
    exists(int i, int j |
      output = TDelegateSummaryOutput(i, j) and
      result = DataFlowPrivate::TSummaryDelegateArgumentNode(c, i, j)
    )
    or
    exists(SummarizableCallable target, ReturnKind rk |
      output = TJumpSummaryOutput(target, rk) and
      result = DataFlowPrivate::TSummaryJumpNode(c, target, rk)
    )
  }

  /** Gets the internal summary node for the given values. */
  Node internalNode(SummarizableCallable c, Impl::Private::SummaryInternalNodeState state) {
    result = DataFlowPrivate::TSummaryInternalNode(c, state)
  }

  /** Gets the type of content `c`. */
  pragma[noinline]
  DataFlowType getContentType(Content c) {
    exists(Type t | result = Gvn::getGlobalValueNumber(t) |
      t = c.(DataFlowPublic::FieldContent).getField().getType()
      or
      t = c.(DataFlowPublic::PropertyContent).getProperty().getType()
      or
      c instanceof DataFlowPublic::ElementContent and
      t instanceof ObjectType // we don't know what the actual element type is
    )
  }
}

module Public {
  private import Private

  /** An unbound callable. */
  class SummarizableCallable extends Callable {
    SummarizableCallable() { this = this.getSourceDeclaration() }
  }

  /** A flow-summary input specification. */
  class SummaryInput extends TSummaryInput {
    /** Gets a textual representation of this input specification. */
    final string toString() {
      exists(int i |
        this = TParameterSummaryInput(i) and
        if i = -1 then result = "this parameter" else result = "parameter " + i
        or
        this = TDelegateSummaryInput(i) and
        result = "deleget output from parameter " + i
      )
    }
  }

  /** A flow-summary output specification. */
  class SummaryOutput extends TSummaryOutput {
    /** Gets a textual representation of this flow sink specification. */
    final string toString() {
      this = TReturnSummaryOutput() and
      result = "return"
      or
      exists(int i |
        this = TParameterSummaryOutput(i) and
        if i = -1 then result = "this parameter" else result = "parameter " + i
      )
      or
      exists(int delegateIndex, int parameterIndex |
        this = TDelegateSummaryOutput(delegateIndex, parameterIndex) and
        result = "parameter " + parameterIndex + " of delegate parameter " + delegateIndex
      )
      or
      exists(SummarizableCallable target, ReturnKind rk |
        this = TJumpSummaryOutput(target, rk) and
        result = "jump to " + target + " (" + rk + ")"
      )
    }
  }
}
