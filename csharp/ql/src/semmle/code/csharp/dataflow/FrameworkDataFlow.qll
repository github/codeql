/**
 * Provides classes and predicates for definining data-flow through frameworks.
 */

import csharp
private import internal.FrameworkDataFlowImpl as Impl
private import internal.FrameworkDataFlowSpecific::Private
private import internal.DataFlowPublic

class FrameworkCallable = Impl::FrameworkCallable;

/** An unbound method. */
class FrameworkMethod extends FrameworkCallable, Method { }

class ContentList = Impl::ContentList;

/** Provides predicates for constructing content lists. */
module ContentList {
  import Impl::ContentList

  /** Gets the singleton "element content" content list. */
  ContentList element() { result = singleton(any(ElementContent c)) }

  /** Gets a singleton property content list. */
  ContentList property(Property p) {
    result = singleton(any(PropertyContent c | c.getProperty() = p.getSourceDeclaration()))
  }

  /** Gets a singleton field content list. */
  ContentList field(Field f) {
    result = singleton(any(FieldContent c | c.getField() = f.getSourceDeclaration()))
  }
}

class SummaryInput = Impl::SummaryInput;

/** Provides predicates for constructing flow-summary input specifications */
module SummaryInput {
  private import semmle.code.csharp.frameworks.system.Collections

  /**
   * Gets an input specification that specifies the `i`th parameter as
   * the input (`i = -1` corresponds to the implicit `this` parameter).
   */
  SummaryInput parameter(int i) { result = TParameterSummaryInput(i) }

  private predicate isCollectionType(ValueOrRefType t) {
    t.getABaseType*() instanceof SystemCollectionsIEnumerableInterface and
    not t instanceof StringType
  }

  /**
   * Gets an input specification that specifies the `i`th parameter as
   * the input (`i = -1` corresponds to the implicit `this` parameter).
   *
   * `inputContents` is either empty or a singleton element content list,
   * depending on whether the type of the `i`th parameter of `c` is a
   * collection type.
   */
  SummaryInput parameter(FrameworkCallable c, int i, ContentList inputContents) {
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
  SummaryInput delegate(FrameworkCallable c, int i) {
    result = delegate(i) and
    hasDelegateArgumentPosition(c, i)
  }
}

class SummaryOutput = Impl::SummaryOutput;

/** Provides predicates for constructing flow-summary output specifications. */
module SummaryOutput {
  /**
   * Gets an output specification that specifies the return value from a call as
   * the output.
   */
  SummaryOutput return() { result = TReturnSummaryOutput() }

  /**
   * Gets an output specification that specifies the `i`th parameter as the
   * output (`i = -1` corresponds to the implicit `this` parameter).
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
  SummaryOutput delegate(FrameworkCallable callable, int i, int j) {
    result = TDelegateSummaryOutput(i, j) and
    hasDelegateArgumentPosition2(callable, i, j)
  }
}

class FlowSource = Impl::FlowSource;

/** Provides predicates for constructing flow-source specifications. */
module FlowSource {
  class Range = Impl::FlowSource::Range;

  private class RemoteFlowSource extends Range {
    RemoteFlowSource() { this = "remote" }
  }

  FlowSource remote() { result = any(RemoteFlowSource s).toFlowSource() }

  private class LocalFlowSource extends Range {
    LocalFlowSource() { this = "local" }
  }

  FlowSource local() { result = any(LocalFlowSource s).toFlowSource() }

  private class StoredFlowSource extends Range {
    StoredFlowSource() { this = "stored" }
  }

  FlowSource stored() { result = any(StoredFlowSource s).toFlowSource() }
}

class FlowSink = Impl::FlowSink;

/** Provides predicates for constructing flow-sink specifications. */
module FlowSink {
  class Range = Impl::FlowSink::Range;

  private class RemoteFlowSink extends Range {
    RemoteFlowSink() { this = "remote" }
  }

  FlowSink remote() { result = any(RemoteFlowSink s).toFlowSink() }

  private class HtmlFlowSink extends Range {
    HtmlFlowSink() { this = "html" }

    override predicate isSubsetOf(FlowSink fs) { fs = remote() }
  }

  FlowSink html() { result = any(HtmlFlowSink s).toFlowSink() }

  private class EmailFlowSink extends Range {
    EmailFlowSink() { this = "email" }

    override predicate isSubsetOf(FlowSink fs) { fs = remote() }
  }

  FlowSink email() { result = any(EmailFlowSink s).toFlowSink() }

  private class SqlFlowSink extends Range {
    SqlFlowSink() { this = "sql" }
  }

  FlowSink sql() { result = any(SqlFlowSink s).toFlowSink() }

  private class CommandFlowSink extends Range {
    CommandFlowSink() { this = "command" }
  }

  FlowSink command() { result = any(CommandFlowSink s).toFlowSink() }
}

class FrameworkDataFlow = Impl::FrameworkDataFlow;

module Examples {
  private import semmle.code.csharp.frameworks.system.Text

  /** Data flow for `System.Text.StringBuilder`. */
  class StringBuilderDataFlow extends FrameworkDataFlow {
    StringBuilderDataFlow() { this = "System.Text.StringBuilder" }

    private SystemTextStringBuilderClass getClass() { any() }

    private predicate constructorFlow(
      Constructor c, SummaryInput input, ContentList inputContents, SummaryOutput output,
      ContentList outputContents
    ) {
      c = this.getClass().getAMember() and
      c.getParameter(0).getType() instanceof StringType and
      input = SummaryInput::parameter(0) and
      inputContents = ContentList::empty() and
      output = SummaryOutput::thisParameter() and
      outputContents = ContentList::element()
    }

    private predicate methodFlow(
      FrameworkMethod m, SummaryInput input, ContentList inputContents, SummaryOutput output,
      ContentList outputContents, boolean preservesValue
    ) {
      exists(string name | m = this.getClass().getAMethod(name) |
        name = "ToString" and
        input = SummaryInput::thisParameter() and
        inputContents = ContentList::element() and
        output = SummaryOutput::thisParameter() and
        outputContents = ContentList::empty() and
        preservesValue = false
        or
        exists(int i, Type t |
          name.regexpMatch("Append(Format|Line)?") and
          t = m.getParameter(i).getType() and
          input = SummaryInput::parameter(i) and
          inputContents = ContentList::empty() and
          output = [SummaryOutput::thisParameter(), SummaryOutput::return()] and
          outputContents = ContentList::element() and
          preservesValue = true
        |
          t instanceof StringType or
          t instanceof ObjectType
        )
      )
    }

    override predicate hasSummary(
      FrameworkCallable c, SummaryInput input, ContentList inputContents, SummaryOutput output,
      ContentList outputContents, boolean preservesValue
    ) {
      (
        this.constructorFlow(c, input, inputContents, output, outputContents) and
        preservesValue = true
        or
        this.methodFlow(c, input, inputContents, output, outputContents, preservesValue)
      )
    }

    override predicate clearsContent(FrameworkCallable c, SummaryInput input, Content content) {
      c = this.getClass().getAMethod("Clear") and
      input = SummaryInput::thisParameter() and
      content instanceof ElementContent
    }
  }

  private import semmle.code.csharp.frameworks.System

  /** Data flow for `System.Lazy`. */
  class LazyDataFlow extends FrameworkDataFlow {
    LazyDataFlow() { this = "System.Lazy" }

    private SystemLazyClass getClass() { any() }

    override predicate hasSummary(
      FrameworkCallable c, SummaryInput input, ContentList inputContents, SummaryOutput output,
      ContentList outputContents, boolean preservesValue
    ) {
      preservesValue = true and
      exists(SystemFuncDelegateType t, int i | t.getNumberOfTypeParameters() = 1 |
        c.(Constructor).getDeclaringType() = this.getClass() and
        c.getParameter(i).getType().getSourceDeclaration() = t and
        input = SummaryInput::delegate(c, i) and
        inputContents = ContentList::empty() and
        output = SummaryOutput::thisParameter() and
        outputContents = ContentList::property(this.getClass().getValueProperty())
      )
      or
      preservesValue = false and
      c = this.getClass().getValueProperty().getGetter() and
      input = SummaryInput::thisParameter() and
      inputContents = ContentList::empty() and
      output = SummaryOutput::thisParameter() and
      outputContents = ContentList::empty()
    }
  }

  private import semmle.code.csharp.frameworks.system.Data
  private import semmle.code.csharp.frameworks.system.data.SqlClient

  class SqlClientDataFlow extends FrameworkDataFlow {
    SqlClientDataFlow() { this = "SqlClientDataFlow" }

    override predicate hasSink(FrameworkCallable c, SummaryInput input, FlowSink sink) {
      sink = FlowSink::sql() and
      (
        exists(Property p, SystemDataIDbCommandInterface i, Property text |
          text = i.getCommandTextProperty() and
          p.overridesOrImplementsOrEquals(text) and
          c = p.getSetter() and
          input = SummaryInput::parameter(0)
        )
        or
        c =
          any(InstanceConstructor ic |
            ic.getDeclaringType().getABaseType*() instanceof SystemDataIDbCommandInterface and
            ic.getParameter(0).getType() instanceof StringType and
            input = SummaryInput::parameter(0)
          )
      )
    }
  }
}
