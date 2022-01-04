/**
 * Provides classes and predicates for tracking data flow through library types.
 */

import csharp
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import semmle.code.csharp.frameworks.system.Text
private import semmle.code.csharp.dataflow.internal.DataFlowPublic
// import `LibraryTypeDataFlow` definitions from other files to avoid potential reevaluation
private import semmle.code.csharp.frameworks.EntityFramework
private import FlowSummary

/** An unbound callable. */
class SourceDeclarationCallable extends Callable {
  SourceDeclarationCallable() { this.isUnboundDeclaration() }
}

/** An unbound method. */
class SourceDeclarationMethod extends SourceDeclarationCallable, Method { }

private newtype TCallableFlowSource =
  TCallableFlowSourceQualifier() or
  TCallableFlowSourceArg(int i) { i = any(Parameter p).getPosition() } or
  TCallableFlowSourceDelegateArg(int i) { hasDelegateArgumentPosition(_, i) }

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

/** A flow source specification. */
class CallableFlowSource extends TCallableFlowSource {
  /** Gets a textual representation of this flow source specification. */
  string toString() { none() }

  /** Gets the source of flow for call `c`, if any. */
  Expr getSource(Call c) { none() }

  /**
   * Gets the type of the source for call `c`. Unlike `getSource()`, this
   * is defined for all flow source specifications.
   */
  Type getSourceType(Call c) { result = this.getSource(c).getType() }
}

/** A flow source specification: (method call) qualifier. */
class CallableFlowSourceQualifier extends CallableFlowSource, TCallableFlowSourceQualifier {
  override string toString() { result = "qualifier" }

  override Expr getSource(Call c) { result = c.getChild(-1) }
}

/** A flow source specification: (method call) argument. */
class CallableFlowSourceArg extends CallableFlowSource, TCallableFlowSourceArg {
  private int i;

  CallableFlowSourceArg() { this = TCallableFlowSourceArg(i) }

  /** Gets the index of this argument. */
  int getArgumentIndex() { result = i }

  override string toString() { result = "argument " + i }

  override Expr getSource(Call c) { result = c.getArgument(i) }
}

/** A flow source specification: output from delegate argument. */
class CallableFlowSourceDelegateArg extends CallableFlowSource, TCallableFlowSourceDelegateArg {
  private int i;

  CallableFlowSourceDelegateArg() { this = TCallableFlowSourceDelegateArg(i) }

  /** Gets the index of this delegate argument. */
  int getArgumentIndex() { result = i }

  override string toString() { result = "output from argument " + i }

  override Expr getSource(Call c) { none() }

  override Type getSourceType(Call c) { result = c.getArgument(i).getType() }
}

private newtype TCallableFlowSink =
  TCallableFlowSinkQualifier() or
  TCallableFlowSinkReturn() or
  TCallableFlowSinkArg(int i) { exists(SourceDeclarationCallable c | exists(c.getParameter(i))) } or
  TCallableFlowSinkDelegateArg(int i, int j) { hasDelegateArgumentPosition2(_, i, j) }

/** A flow sink specification. */
class CallableFlowSink extends TCallableFlowSink {
  /** Gets a textual representation of this flow sink specification. */
  string toString() { none() }

  /** Gets the sink of flow for call `c`, if any. */
  Expr getSink(Call c) { none() }
}

/** A flow sink specification: (method call) qualifier. */
class CallableFlowSinkQualifier extends CallableFlowSink, TCallableFlowSinkQualifier {
  override string toString() { result = "qualifier" }

  override Expr getSink(Call c) { result = c.getChild(-1) }
}

/** A flow sink specification: return value. */
class CallableFlowSinkReturn extends CallableFlowSink, TCallableFlowSinkReturn {
  override string toString() { result = "return" }

  override Expr getSink(Call c) { result = c }
}

/** A flow sink specification: (method call) argument. */
class CallableFlowSinkArg extends CallableFlowSink, TCallableFlowSinkArg {
  private int i;

  CallableFlowSinkArg() { this = TCallableFlowSinkArg(i) }

  /** Gets the index of this `out`/`ref` argument. */
  int getArgumentIndex() { result = i }

  /** Gets the `out`/`ref` argument of method call `mc` matching this specification. */
  Expr getArgument(MethodCall mc) {
    exists(Parameter p |
      p = mc.getTarget().getParameter(i) and
      p.isOutOrRef() and
      result = mc.getArgumentForParameter(p)
    )
  }

  override string toString() { result = "argument " + i }

  override Expr getSink(Call c) {
    // The uses of the `i`th argument are the actual sinks
    none()
  }
}

/** A flow sink specification: parameter of a delegate argument. */
class CallableFlowSinkDelegateArg extends CallableFlowSink, TCallableFlowSinkDelegateArg {
  private int delegateIndex;
  private int parameterIndex;

  CallableFlowSinkDelegateArg() {
    this = TCallableFlowSinkDelegateArg(delegateIndex, parameterIndex)
  }

  /** Gets the index of the delegate argument. */
  int getDelegateIndex() { result = delegateIndex }

  /** Gets the index of the delegate parameter. */
  int getDelegateParameterIndex() { result = parameterIndex }

  override string toString() {
    result = "parameter " + parameterIndex + " of argument " + delegateIndex
  }

  override Expr getSink(Call c) {
    // The uses of the `j`th parameter are the actual sinks
    none()
  }
}

/** A specification of data flow for a library (non-source code) type. */
abstract class LibraryTypeDataFlow extends Type {
  LibraryTypeDataFlow() { this = this.getUnboundDeclaration() }

  /**
   * Holds if values stored inside `content` are cleared on objects passed as
   * arguments of type `source` to calls that target `callable`.
   */
  pragma[nomagic]
  predicate clearsContent(
    CallableFlowSource source, Content content, SourceDeclarationCallable callable
  ) {
    none()
  }
}

/**
 * An internal module for translating old `LibraryTypeDataFlow`-style
 * flow summaries into the new style.
 */
private module FrameworkDataFlowAdaptor {
  private CallableFlowSource toCallableFlowSource(SummaryComponentStack input) {
    result = TCallableFlowSourceQualifier() and
    input = SummaryComponentStack::qualifier()
    or
    exists(int i |
      result = TCallableFlowSourceArg(i) and
      input = SummaryComponentStack::argument(i)
    )
    or
    exists(int i | result = TCallableFlowSourceDelegateArg(i) |
      input =
        SummaryComponentStack::push(SummaryComponent::return(), SummaryComponentStack::argument(i))
    )
  }

  private class FrameworkDataFlowAdaptor extends SummarizedCallable {
    private LibraryTypeDataFlow ltdf;

    FrameworkDataFlowAdaptor() { ltdf.clearsContent(_, _, this) }

    override predicate clearsContent(ParameterPosition pos, Content content) {
      exists(SummaryComponentStack input |
        ltdf.clearsContent(toCallableFlowSource(input), content, this) and
        input = SummaryComponentStack::argument(pos.getPosition())
      )
    }
  }

  private class AdaptorRequiredSummaryComponentStack extends RequiredSummaryComponentStack {
    private SummaryComponent head;

    AdaptorRequiredSummaryComponentStack() {
      exists(int i |
        exists(TCallableFlowSourceDelegateArg(i)) and
        head = SummaryComponent::return() and
        this = SummaryComponentStack::singleton(SummaryComponent::argument(i))
      )
      or
      exists(int i, int j | exists(TCallableFlowSinkDelegateArg(i, j)) |
        head = SummaryComponent::parameter(j) and
        this = SummaryComponentStack::singleton(SummaryComponent::argument(i))
      )
    }

    override predicate required(SummaryComponent c) { c = head }
  }
}

/** Data flow for `System.Text.StringBuilder`. */
class SystemTextStringBuilderFlow extends LibraryTypeDataFlow, SystemTextStringBuilderClass {
  override predicate clearsContent(
    CallableFlowSource source, Content content, SourceDeclarationCallable callable
  ) {
    source = TCallableFlowSourceQualifier() and
    callable = this.getAMethod("Clear") and
    content instanceof ElementContent
  }
}

/** Data flow for `System.Collections.IEnumerable` (and sub types). */
class IEnumerableFlow extends LibraryTypeDataFlow, RefType {
  IEnumerableFlow() { this.getABaseType*() instanceof SystemCollectionsIEnumerableInterface }

  override predicate clearsContent(
    CallableFlowSource source, Content content, SourceDeclarationCallable callable
  ) {
    source = TCallableFlowSourceQualifier() and
    callable = this.getAMethod("Clear") and
    content instanceof ElementContent
  }
}

private predicate recordConstructorFlow(Constructor c, int i, Property p) {
  c = any(Record r).getAMember() and
  exists(string name |
    c.getParameter(i).getName() = name and
    c.getDeclaringType().getAMember(name) = p
  )
}

private class RecordConstructorFlowRequiredSummaryComponentStack extends RequiredSummaryComponentStack {
  private SummaryComponent head;

  RecordConstructorFlowRequiredSummaryComponentStack() {
    exists(Property p |
      recordConstructorFlow(_, _, p) and
      head = SummaryComponent::property(p) and
      this = SummaryComponentStack::singleton(SummaryComponent::return())
    )
  }

  override predicate required(SummaryComponent c) { c = head }
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
