/**
 * Provides classes and predicates for definining flow summaries.
 */

import python
private import internal.FlowSummaryImpl as Impl
private import internal.FlowSummarySpecific::Private
private import internal.DataFlowPublic as DataFlowPublic
// import all instances below
private import semmle.python.dataflow.new.FlowSummaries

class SummarizableCallable = Impl::Public::SummarizableCallable;

/** An unbound method. */
class ContentList =
  // class SummarizableMethod extends SummarizableCallable, Method { }
  Impl::Public::ContentList;

/** Provides predicates for constructing content lists. */
module ContentList {
  import Impl::Public::ContentList

  /** Gets the singleton "list element content" content list. */
  ContentList listElement() { result = singleton(any(DataFlowPublic::ListElementContent c)) }

  /** Gets a singleton attribute content list. */
  ContentList attribute(Attribute a) {
    result = singleton(any(DataFlowPublic::AttributeContent c | c.getAttribute() = a.getAttr()))
  }
}

class SummaryInput = Impl::Public::SummaryInput;

/** Provides predicates for constructing flow-summary input specifications */
module SummaryInput {
  /**
   * Gets an input specification that specifies the `i`th parameter as
   * the input.
   */
  SummaryInput parameter(int i) { result = TParameterSummaryInput(i) }

  /**
   * Gets an input specification that specifies the `i`th parameter as
   * the input.
   *
   * `inputContents` is either empty or a singleton element content list,
   * depending on whether the type of the `i`th parameter of `c` is a
   * collection type.
   */
  SummaryInput parameter(SummarizableCallable c, int i, ContentList inputContents) {
    result = parameter(i) and
    exists(Parameter p |
      p.asName() = c.getParameter(i).getNode() and
      inputContents = ContentList::empty()
    )
  }

  /**
   * Gets an input specification that specifies the explicit `this` parameter
   * as the input.
   */
  SummaryInput thisParameter() { result = TParameterSummaryInput(0) }
}

class SummaryOutput = Impl::Public::SummaryOutput;

/** Provides predicates for constructing flow-summary output specifications. */
module SummaryOutput {
  /**
   * Gets an output specification that specifies the return value from a call as
   * the output.
   */
  SummaryOutput return() { result = TReturnSummaryOutput() }
}

class SummarizedCallable = Impl::Public::SummarizedCallable;

/** Provides a query predicate for outputting a set of relevant flow summaries. */
module TestOutput {
  /** A flow summary to include in the `summary/3` query predicate. */
  abstract class RelevantSummarizedCallable extends SummarizedCallable { }

  /** A query predicate for outputting flow summaries in QL tests. */
  query predicate summary(string callable, string flow, boolean preservesValue) {
    exists(
      RelevantSummarizedCallable c, SummaryInput input, ContentList inputContents,
      string inputContentsString, SummaryOutput output, ContentList outputContents,
      string outputContentsString
    |
      callable = c.getName() and
      Impl::Private::summary(c, input, inputContents, output, outputContents, preservesValue) and
      (
        if inputContents.length() = 0
        then inputContentsString = ""
        else inputContentsString = " [" + inputContents + "]"
      ) and
      (
        if outputContents.length() = 0
        then outputContentsString = ""
        else outputContentsString = " [" + outputContents + "]"
      ) and
      flow = input + inputContentsString + " -> " + output + outputContentsString
    )
  }

  private class IncludeAllSummarizedCallable extends RelevantSummarizedCallable {
    IncludeAllSummarizedCallable() { this instanceof SummarizedCallable }
  }

  predicate testCalls(SummarizedCallable c, CallNode cn) { cn = c.getCallableValue().getACall() }
}
