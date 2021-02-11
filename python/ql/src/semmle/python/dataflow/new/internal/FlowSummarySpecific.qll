/**
 * Provides Python specific classes and predicates for definining flow summaries.
 */

private import python

module Private {
  private import Public
  private import DataFlowPrivate as DataFlowPrivate
  private import DataFlowPublic as DataFlowPublic
  private import FlowSummaryImpl as Impl

  class Content = DataFlowPublic::Content;

  class DataFlowType = DataFlowPrivate::DataFlowType;

  class Node = DataFlowPublic::Node;

  class DataFlowCallableValue = DataFlowPrivate::DataFlowCallableValue;

  class ParameterNode = DataFlowPublic::ParameterNode;

  class ArgumentNode = DataFlowPublic::ArgumentNode;

  class ReturnNode = DataFlowPrivate::ReturnNode;

  class OutNode = DataFlowPrivate::OutNode;

  class ReturnKind = DataFlowPrivate::ReturnKind;

  predicate accessPathLimit = DataFlowPrivate::accessPathLimit/0;

  newtype TSummaryInput =
    TParameterSummaryInput(int i) { i in [-1, any(Parameter p).getPosition()] }

  newtype TSummaryOutput = TReturnSummaryOutput()

  //   /** Gets the return kind that matches `sink`, if any. */
  //   ReturnKind toReturnKind(SummaryOutput output) {
  //     output = TReturnSummaryOutput() and
  //     result instanceof NormalReturnKind
  //     or
  //     exists(int i | output = TParameterSummaryOutput(i) |
  //       i = -1 and
  //       result instanceof QualifierReturnKind
  //       or
  //       i = result.(OutRefReturnKind).getPosition()
  //     )
  //   }
  /** Gets the input node for `c` of type `input`. */
  Node inputNode(SummarizableCallable c, SummaryInput input) {
    exists(int i |
      input = TParameterSummaryInput(i) and
      result.(ParameterNode).isParameterOf(c, i)
    )
  }

  /** Gets the output node for `c` of type `output`. */
  Node outputNode(SummarizableCallable c, SummaryOutput output) {
    result = DataFlowPublic::TSummaryReturnNode(c) and
    output = TReturnSummaryOutput()
  }

  /** Gets the internal summary node for the given values. */
  Node internalNode(SummarizableCallable c, Impl::Private::SummaryInternalNodeState state) {
    result = DataFlowPublic::TSummaryInternalNode(c, state)
  }

  /** Gets the type of content `c`. */
  pragma[noinline]
  DataFlowType getContentType(Content c) { result = DataFlowPrivate::TAnyFlow() and c = c }
}

module Public {
  private import Private

  /** An unbound callable. */
  class SummarizableCallable extends DataFlowCallableValue {
    // SummarizableCallable() { this.getCallableValue().isBuiltin() } // TODO: need to find the right constraint here
  }

  /** A flow-summary input specification. */
  class SummaryInput extends TSummaryInput {
    /** Gets a textual representation of this input specification. */
    final string toString() {
      exists(int i |
        this = TParameterSummaryInput(i) and
        if i = -1 then result = "this parameter" else result = "parameter " + i
      )
    }
  }

  /** A flow-summary output specification. */
  class SummaryOutput extends TSummaryOutput {
    /** Gets a textual representation of this flow sink specification. */
    final string toString() {
      this = TReturnSummaryOutput() and
      result = "return"
    }
  }
}
