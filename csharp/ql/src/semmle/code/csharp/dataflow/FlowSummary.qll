/**
 * Provides classes and predicates for definining flow summaries.
 */

import csharp
private import internal.FlowSummaryImpl as Impl
private import internal.FlowSummarySpecific::Private
private import internal.DataFlowPublic as DataFlowPublic
// import all instances below
private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
private import semmle.code.csharp.frameworks.EntityFramework

class SummarizableCallable = Impl::Public::SummarizableCallable;

/** An unbound method. */
class SummarizableMethod extends SummarizableCallable, Method { }

class ContentList = Impl::Public::ContentList;

/** Provides predicates for constructing content lists. */
module ContentList {
  import Impl::Public::ContentList

  /** Gets the singleton "element content" content list. */
  ContentList element() { result = singleton(any(DataFlowPublic::ElementContent c)) }

  /** Gets a singleton property content list. */
  ContentList property(Property p) {
    result =
      singleton(any(DataFlowPublic::PropertyContent c | c.getProperty() = p.getSourceDeclaration()))
  }

  /** Gets a singleton field content list. */
  ContentList field(Field f) {
    result =
      singleton(any(DataFlowPublic::FieldContent c | c.getField() = f.getSourceDeclaration()))
  }
}

class SummaryInput = Impl::Public::SummaryInput;

/** Provides predicates for constructing flow-summary input specifications */
module SummaryInput {
  private import semmle.code.csharp.frameworks.system.Collections

  /**
   * Gets an input specification that specifies the `i`th parameter as
   * the input.
   */
  SummaryInput parameter(int i) { result = TParameterSummaryInput(i) }

  private predicate isCollectionType(ValueOrRefType t) {
    t.getABaseType*() instanceof SystemCollectionsIEnumerableInterface and
    not t instanceof StringType
  }

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
      p = c.getParameter(i) and
      if isCollectionType(p.getType())
      then inputContents = ContentList::element()
      else inputContents = ContentList::empty()
    )
  }

  /**
   * Gets an input specification that specifies the implicit `this` parameter
   * as the input.
   */
  SummaryInput thisParameter() { result = TParameterSummaryInput(-1) }

  /**
   * Gets an input specification that specifies output from the delegate at
   * parameter `i` as the input.
   */
  SummaryInput delegate(int i) { result = TDelegateSummaryInput(i) }

  /**
   * Gets an input specification that specifies output from the delegate at
   * parameter `i` as the input.
   *
   * `c` must be a compatible callable, that is, a callable where the `i`th
   * parameter is a delegate.
   */
  SummaryInput delegate(SummarizableCallable c, int i) {
    result = delegate(i) and
    hasDelegateArgumentPosition(c, i)
  }
}

class SummaryOutput = Impl::Public::SummaryOutput;

/** Provides predicates for constructing flow-summary output specifications. */
module SummaryOutput {
  /**
   * Gets an output specification that specifies the return value from a call as
   * the output.
   */
  SummaryOutput return() { result = TReturnSummaryOutput() }

  /**
   * Gets an output specification that specifies the `i`th parameter as the
   * output.
   */
  SummaryOutput parameter(int i) { result = TParameterSummaryOutput(i) }

  /**
   * Gets an output specification that specifies the implicit `this` parameter
   * as the output.
   */
  SummaryOutput thisParameter() { result = TParameterSummaryOutput(-1) }

  /**
   * Gets an output specification that specifies parameter `j` of the delegate at
   * parameter `i` as the output.
   */
  SummaryOutput delegate(int i, int j) { result = TDelegateSummaryOutput(i, j) }

  /**
   * Gets an output specification that specifies parameter `j` of the delegate at
   * parameter `i` as the output.
   *
   * `c` must be a compatible callable, that is, a callable where the `i`th
   * parameter is a delegate with a parameter at position `j`.
   */
  SummaryOutput delegate(SummarizableCallable c, int i, int j) {
    result = TDelegateSummaryOutput(i, j) and
    hasDelegateArgumentPosition2(c, i, j)
  }

  /**
   * Gets an output specification that specifies the `output` of `target` as the
   * output. That is, data will flow into one callable and out of another callable
   * (`target`).
   *
   * `output` is limited to (this) parameters and ordinary returns.
   */
  SummaryOutput jump(SummarizableCallable target, SummaryOutput output) {
    result = TJumpSummaryOutput(target, toReturnKind(output))
  }
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
      callable = c.getQualifiedNameWithTypes() and
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
}
