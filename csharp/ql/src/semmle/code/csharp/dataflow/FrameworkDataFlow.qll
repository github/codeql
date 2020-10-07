/**
 * Provides classes and predicates for definining data-flow through frameworks.
 */

import csharp
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.DataFlowPublic
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.collections.Generic
private import semmle.code.csharp.frameworks.system.linq.Expressions

/** An unbound callable. */
class SourceDeclarationCallable extends Callable {
  SourceDeclarationCallable() { this = this.getSourceDeclaration() }
}

/** An unbound method. */
class SourceDeclarationMethod extends SourceDeclarationCallable, Method { }

private predicate hasDelegateArgumentPosition(SourceDeclarationCallable c, int i) {
  exists(DelegateType dt |
    dt = c.getParameter(i).getType().(SystemLinqExpressions::DelegateExtType).getDelegateType()
  |
    not dt.getReturnType() instanceof VoidType
  )
}

private predicate hasDelegateArgumentPosition2(SourceDeclarationCallable c, int i, int j) {
  exists(DelegateType dt |
    dt = c.getParameter(i).getType().(SystemLinqExpressions::DelegateExtType).getDelegateType()
  |
    exists(dt.getParameter(j))
  )
}

/** INTERNAL: Do not use. */
module Internal {
  newtype TContentStack =
    TNilContentStack() or
    TPushContentStack(Content head, ContentStack tail) {
      tail = TNilContentStack()
      or
      exists(FrameworkDataFlow fdf |
        fdf.requiresContentStack(head, tail) and
        tail.length() < accessPathLimit()
      )
      or
      tail = ContentStack::singleton(_) and
      head instanceof ElementContent
      or
      tail = ContentStack::element()
    }

  newtype TSummaryInput =
    TQualifierSummaryInput() or
    TArgumentSummaryInput(int i) { i = any(Parameter p).getPosition() } or
    TDelegateSummaryInput(int i) { hasDelegateArgumentPosition(_, i) }

  newtype TSummaryOutput =
    TQualifierSummaryOutput() or
    TReturnSummaryOutput() or
    TArgumentSummaryOutput(int i) {
      exists(SourceDeclarationCallable c | exists(c.getParameter(i)))
    } or
    TDelegateSummaryOutput(int i, int j) { hasDelegateArgumentPosition2(_, i, j) }

  newtype TFlowSource =
    TRemoteFlowSource() or
    TLocalFlowSource() or
    TStoredFlowSource()

  newtype TFlowSink =
    TRemoteFlowSink() or
    THtmlFlowSink() or
    TEmailFlowSink() or
    TSqlFlowSink() or
    TCommandFlowSink()

  /** Holds if a flow-source of kind `a` is also a flow-source of kind `b`. */
  predicate flowSourceSubset(FlowSource a, FlowSource b) { none() }

  /** Holds if a flow-sink of kind `a` is also a flow-sink of kind `b`. */
  predicate flowSinkSubset(FlowSink a, FlowSink b) {
    a in [THtmlFlowSink().(FlowSink), TEmailFlowSink().(FlowSink)] and
    b = TRemoteFlowSink()
  }
}

private import Internal

/** A content stack. */
class ContentStack extends TContentStack {
  /** Gets the content stack obtained by popping `c` from this stack, if any. */
  ContentStack pop(Content c) { this = TPushContentStack(c, result) }

  /** Gets the length of this content stack. */
  int length() {
    this = TNilContentStack() and result = 0
    or
    result = 1 + this.pop(_).length()
  }

  /** Gets the content stack obtained by dropping the first `i` elements, if any. */
  ContentStack drop(int i) {
    i = 0 and result = this
    or
    result = this.pop(_).drop(i - 1)
  }

  /** Holds if this content stack contains content `c`. */
  predicate contains(Content c) { exists(this.drop(_).pop(c)) }

  /** Gets a textual representation of this content stack. */
  string toString() {
    exists(Content head, ContentStack tail |
      tail = this.pop(head) and
      if tail.length() = 0 then result = head.toString() else result = head + ", " + tail
    )
    or
    this = TNilContentStack() and
    result = "<empty>"
  }
}

/** Provides predicates for constructing content stacks. */
module ContentStack {
  /** Gets the empty content stack. */
  ContentStack empty() { result = TNilContentStack() }

  /** Gets a singleton content stack containing `c`. */
  ContentStack singleton(Content c) { result = TPushContentStack(c, TNilContentStack()) }

  /** Gets the content stack obtained by pushing `head` onto `tail`. */
  ContentStack push(Content head, ContentStack tail) { result = TPushContentStack(head, tail) }

  /** Gets the singleton "element content" content stack. */
  ContentStack element() { result = singleton(any(ElementContent c)) }

  /** Gets a singleton property content stack. */
  ContentStack property(Property p) {
    result = singleton(any(PropertyContent c | c.getProperty() = p.getSourceDeclaration()))
  }

  /** Gets a singleton field content stack. */
  ContentStack field(Field f) {
    result = singleton(any(FieldContent c | c.getField() = f.getSourceDeclaration()))
  }
}

/** A flow-summary input specification. */
class SummaryInput extends TSummaryInput {
  /** Gets a textual representation of this input specification. */
  final string toString() {
    this = TQualifierSummaryInput() and
    result = "qualifier"
    or
    exists(int i |
      this = TArgumentSummaryInput(i) and
      result = "argument " + i
      or
      this = TDelegateSummaryInput(i) and
      result = "output from argument " + i
    )
  }
}

/** Provides predicate for constructing flow-summary input specifications */
module SummaryInput {
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
  SummaryInput argument(SourceDeclarationCallable c, int i, ContentStack inputStack) {
    result = argument(i) and
    exists(Parameter p |
      p = c.getParameter(i) and
      if isCollectionType(p.getType())
      then inputStack = ContentStack::element()
      else inputStack = ContentStack::empty()
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
  SummaryInput delegate(SourceDeclarationCallable c, int i) {
    result = delegate(i) and
    hasDelegateArgumentPosition(c, i)
  }
}

/** A flow-summary output specification. */
class SummaryOutput extends TSummaryOutput {
  /** Gets a textual representation of this flow sink specification. */
  final string toString() {
    this = TQualifierSummaryOutput() and
    result = "qualifier"
    or
    this = TReturnSummaryOutput() and
    result = "return"
    or
    exists(int i |
      this = TArgumentSummaryOutput(i) and
      result = "argument " + i
    )
    or
    exists(int delegateIndex, int parameterIndex |
      this = TDelegateSummaryOutput(delegateIndex, parameterIndex) and
      result = "parameter " + parameterIndex + " of argument " + delegateIndex
    )
  }
}

/** Provides predicate for constructing flow-summary output specifications. */
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
  SummaryOutput delegate(SourceDeclarationCallable callable, int i, int j) {
    result = TDelegateSummaryOutput(i, j) and
    hasDelegateArgumentPosition2(callable, i, j)
  }
}

/** A flow-source specification. */
class FlowSource extends TFlowSource {
  final string toString() {
    this = TRemoteFlowSource() and
    result = "remote"
    or
    this = TLocalFlowSource() and
    result = "local"
    or
    this = TStoredFlowSource() and
    result = "stored"
  }
}

/** Provides predicates for constructing flow-source specifications. */
module FlowSource {
  FlowSource remote() { result = TRemoteFlowSource() }

  FlowSource local() { result = TLocalFlowSource() }

  FlowSource stored() { result = TStoredFlowSource() }
}

/** A flow-sink specification. */
class FlowSink extends TFlowSink {
  final string toString() {
    this = TRemoteFlowSink() and
    result = "remote"
    or
    this = THtmlFlowSink() and
    result = "html"
    or
    this = TEmailFlowSink() and
    result = "email"
    or
    this = TSqlFlowSink() and
    result = "sql"
    or
    this = TCommandFlowSink() and
    result = "command"
  }
}

/** Provides predicates for constructing flow-sink specifications. */
module FlowSink {
  FlowSink remote() { result = TRemoteFlowSink() }

  FlowSink html() { result = THtmlFlowSink() }

  FlowSink email() { result = TEmailFlowSink() }

  FlowSink sql() { result = TSqlFlowSink() }

  FlowSink command() { result = TCommandFlowSink() }
}

/** A data-flow model for a given framework. */
abstract class FrameworkDataFlow extends string {
  bindingset[this]
  FrameworkDataFlow() { any() }

  /**
   * Holds if data may flow from `input` to `output` when calling `c`.
   *
   * `inputStack` describes the contents that is popped from the access
   * path from the input and `outputStack` describes the contents that
   * is pushed onto the resulting access path.
   *
   * `preservesValue` indicates whether this is a value-preserving step
   * or a taint-step.
   */
  pragma[nomagic]
  predicate hasSummary(
    SourceDeclarationCallable c, SummaryInput input, ContentStack inputStack, SummaryOutput output,
    ContentStack outputStack, boolean preservesValue
  ) {
    none()
  }

  /**
   * Holds if the content stack obtained by pushing `head` onto `tail` is
   * needed for a summary specified by `hasSummary()`.
   *
   * This predicate is needed for QL technical reasons only (the IPA type used
   * to represent content stacks needs to be bounded).
   */
  pragma[nomagic]
  predicate requiresContentStack(Content head, ContentStack tail) { none() }

  /**
   * Holds if values stored inside `content` are cleared on objects passed as
   * arguments of type `input` to calls that target `c`.
   */
  pragma[nomagic]
  predicate clearsContent(SourceDeclarationCallable c, SummaryInput input, Content content) {
    none()
  }

  /** Holds if `n` is a flow source of type `source. */
  pragma[nomagic]
  predicate hasSource(DataFlow::Node n, FlowSource source) { none() }

  /** Holds if `n` is a flow sink of type `sink. */
  pragma[nomagic]
  predicate hasSink(DataFlow::Node n, FlowSink sink) { none() }
}

module Examples {
  private import semmle.code.csharp.frameworks.system.Text

  /** Data flow for `System.Text.StringBuilder`. */
  class StringBuilderDataFlow extends FrameworkDataFlow {
    StringBuilderDataFlow() { this = "System.Text.StringBuilder" }

    private SystemTextStringBuilderClass getClass() { any() }

    private predicate constructorFlow(
      Constructor c, SummaryInput input, ContentStack inputAp, SummaryOutput output,
      ContentStack outputAp
    ) {
      c = this.getClass().getAMember() and
      c.getParameter(0).getType() instanceof StringType and
      input = TArgumentSummaryInput(0) and
      inputAp = ContentStack::empty() and
      output = TReturnSummaryOutput() and
      outputAp = ContentStack::element()
    }

    private predicate methodFlow(
      SourceDeclarationMethod m, SummaryInput input, ContentStack inputAp, SummaryOutput output,
      ContentStack outputAp, boolean preservesValue
    ) {
      exists(string name | m = this.getClass().getAMethod(name) |
        name = "ToString" and
        input = TQualifierSummaryInput() and
        inputAp = ContentStack::element() and
        output = TReturnSummaryOutput() and
        outputAp = ContentStack::empty() and
        preservesValue = false
        or
        exists(int i, Type t |
          name.regexpMatch("Append(Format|Line)?") and
          t = m.getParameter(i).getType() and
          input = TArgumentSummaryInput(i) and
          inputAp = ContentStack::empty() and
          output = [TQualifierSummaryOutput().(TSummaryOutput), TReturnSummaryOutput()] and
          outputAp = ContentStack::element() and
          preservesValue = true
        |
          t instanceof StringType or
          t instanceof ObjectType
        )
      )
    }

    override predicate hasSummary(
      SourceDeclarationCallable c, SummaryInput input, ContentStack inputStack,
      SummaryOutput output, ContentStack outputStack, boolean preservesValue
    ) {
      (
        this.constructorFlow(c, input, inputStack, output, outputStack) and
        preservesValue = true
        or
        this.methodFlow(c, input, inputStack, output, outputStack, preservesValue)
      )
    }

    override predicate clearsContent(
      SourceDeclarationCallable c, SummaryInput input, Content content
    ) {
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
      SourceDeclarationCallable c, SummaryInput input, ContentStack inputStack,
      SummaryOutput output, ContentStack outputStack, boolean preservesValue
    ) {
      preservesValue = true and
      exists(SystemFuncDelegateType t, int i | t.getNumberOfTypeParameters() = 1 |
        c.(Constructor).getDeclaringType() = this.getClass() and
        c.getParameter(i).getType().getSourceDeclaration() = t and
        input = SummaryInput::delegate(c, i) and
        inputStack = ContentStack::empty() and
        output = TReturnSummaryOutput() and
        outputStack = ContentStack::property(this.getClass().getValueProperty())
      )
      or
      preservesValue = false and
      c = this.getClass().getValueProperty().getGetter() and
      input = TQualifierSummaryInput() and
      inputStack = ContentStack::empty() and
      output = TReturnSummaryOutput() and
      outputStack = ContentStack::empty()
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
