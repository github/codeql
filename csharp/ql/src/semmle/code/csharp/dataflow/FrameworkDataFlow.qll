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

  /** Gets a singleton property content stack. */
  ContentList property(Property p) {
    result = singleton(any(PropertyContent c | c.getProperty() = p.getSourceDeclaration()))
  }

  /** Gets a singleton field content stack. */
  ContentList field(Field f) {
    result = singleton(any(FieldContent c | c.getField() = f.getSourceDeclaration()))
  }
}

class SummaryInput = Impl::SummaryInput;

/** Provides predicates for constructing flow-summary input specifications */
module SummaryInput {
  private import semmle.code.csharp.frameworks.system.Collections

  /**
   * Gets an input specification that specifies the qualifier in a call as
   * the input.
   */
  SummaryInput qualifier() { result = TQualifierSummaryInput() }

  /**
   * Gets an input specification that specifies the `i`th argument in a call as
   * the input.
   */
  SummaryInput argument(int i) { result = TArgumentSummaryInput(i) }

  private predicate isCollectionType(ValueOrRefType t) {
    t.getABaseType*() instanceof SystemCollectionsIEnumerableInterface and
    not t instanceof StringType
  }

  /**
   * Gets an input specification that specifies the `i`th argument as the input.
   *
   * `inputStack` is either empty or a singleton element content stack, depending
   * on whether the type of the `i`th parameter of `c` is a collection type.
   */
  SummaryInput argument(FrameworkCallable c, int i, ContentList inputStack) {
    result = argument(i) and
    exists(Parameter p |
      p = c.getParameter(i) and
      if isCollectionType(p.getType())
      then inputStack = ContentList::element()
      else inputStack = ContentList::empty()
    )
  }

  /**
   * Gets an input specification that specifies output from the delegate at
   * argument `i` as the input.
   */
  SummaryInput delegate(int i) { result = TDelegateSummaryInput(i) }

  /**
   * Gets an input specification that specifies output from the delegate at
   * argument `i` as the input.
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
   * Gets an output specification that specifies the qualifier in a call as
   * the output.
   */
  SummaryOutput qualifier() { result = TQualifierSummaryOutput() }

  /**
   * Gets an output specification that specifies the return value from a call as
   * the output.
   */
  SummaryOutput return() { result = TReturnSummaryOutput() }

  /**
   * Gets an output specification that specifies the `i`th argument in a call as
   * the output.
   */
  SummaryOutput argument(int i) { result = TArgumentSummaryOutput(i) }

  /**
   * Gets an output specification that specifies parameter `j` of the delegate at
   * argument `i` as the output.
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
      Constructor c, SummaryInput input, ContentList inputAp, SummaryOutput output,
      ContentList outputAp
    ) {
      c = this.getClass().getAMember() and
      c.getParameter(0).getType() instanceof StringType and
      input = TArgumentSummaryInput(0) and
      inputAp = ContentList::empty() and
      output = TReturnSummaryOutput() and
      outputAp = ContentList::element()
    }

    private predicate methodFlow(
      FrameworkMethod m, SummaryInput input, ContentList inputAp, SummaryOutput output,
      ContentList outputAp, boolean preservesValue
    ) {
      exists(string name | m = this.getClass().getAMethod(name) |
        name = "ToString" and
        input = TQualifierSummaryInput() and
        inputAp = ContentList::element() and
        output = TReturnSummaryOutput() and
        outputAp = ContentList::empty() and
        preservesValue = false
        or
        exists(int i, Type t |
          name.regexpMatch("Append(Format|Line)?") and
          t = m.getParameter(i).getType() and
          input = TArgumentSummaryInput(i) and
          inputAp = ContentList::empty() and
          output = [TQualifierSummaryOutput().(TSummaryOutput), TReturnSummaryOutput()] and
          outputAp = ContentList::element() and
          preservesValue = true
        |
          t instanceof StringType or
          t instanceof ObjectType
        )
      )
    }

    override predicate hasSummary(
      FrameworkCallable c, SummaryInput input, ContentList inputStack, SummaryOutput output,
      ContentList outputStack, boolean preservesValue
    ) {
      (
        this.constructorFlow(c, input, inputStack, output, outputStack) and
        preservesValue = true
        or
        this.methodFlow(c, input, inputStack, output, outputStack, preservesValue)
      )
    }

    override predicate clearsContent(FrameworkCallable c, SummaryInput input, Content content) {
      c = this.getClass().getAMethod("Clear") and
      input = TQualifierSummaryInput() and
      content instanceof ElementContent
    }
  }

  private import semmle.code.csharp.frameworks.System

  /** Data flow for `System.Lazy`. */
  class LazyDataFlow extends FrameworkDataFlow {
    LazyDataFlow() { this = "System.Lazy" }

    private SystemLazyClass getClass() { any() }

    override predicate hasSummary(
      FrameworkCallable c, SummaryInput input, ContentList inputStack, SummaryOutput output,
      ContentList outputStack, boolean preservesValue
    ) {
      preservesValue = true and
      exists(SystemFuncDelegateType t, int i | t.getNumberOfTypeParameters() = 1 |
        c.(Constructor).getDeclaringType() = this.getClass() and
        c.getParameter(i).getType().getSourceDeclaration() = t and
        input = SummaryInput::delegate(c, i) and
        inputStack = ContentList::empty() and
        output = TReturnSummaryOutput() and
        outputStack = ContentList::property(this.getClass().getValueProperty())
      )
      or
      preservesValue = false and
      c = this.getClass().getValueProperty().getGetter() and
      input = TQualifierSummaryInput() and
      inputStack = ContentList::empty() and
      output = TReturnSummaryOutput() and
      outputStack = ContentList::empty()
    }
  }

  private import semmle.code.csharp.frameworks.system.Data
  private import semmle.code.csharp.frameworks.system.data.SqlClient

  class SqlClientDataFlow extends FrameworkDataFlow {
    SqlClientDataFlow() { this = "SqlClientDataFlow" }

    override predicate hasSink(Node n, FlowSink sink) {
      sink = FlowSink::sql() and
      (
        exists(Property p, SystemDataIDbCommandInterface i, Property text |
          text = i.getCommandTextProperty() and
          p.overridesOrImplementsOrEquals(text) and
          n.(ParameterNode).getParameter() = p.getSetter().getAParameter()
        )
        or
        exists(InstanceConstructor ic | ic = n.asExpr().(ObjectCreation).getTarget() |
          ic.getDeclaringType().getABaseType*() instanceof SystemDataIDbCommandInterface and
          ic.getParameter(0).getType() instanceof StringType
        )
      )
    }
  }
}
