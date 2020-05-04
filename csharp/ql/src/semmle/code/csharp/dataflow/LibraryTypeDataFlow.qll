/**
 * Provides classes and predicates for tracking data flow through library types.
 */

import csharp
private import semmle.code.csharp.frameworks.WCF
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.collections.Generic
private import semmle.code.csharp.frameworks.system.IO
private import semmle.code.csharp.frameworks.system.io.Compression
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import semmle.code.csharp.frameworks.system.Net
private import semmle.code.csharp.frameworks.system.Text
private import semmle.code.csharp.frameworks.system.threading.Tasks
private import semmle.code.csharp.frameworks.system.Web
private import semmle.code.csharp.frameworks.system.web.ui.WebControls
private import semmle.code.csharp.frameworks.system.Xml
private import semmle.code.csharp.dataflow.internal.DataFlowPublic
private import semmle.code.csharp.dataflow.internal.DelegateDataFlow

private newtype TAccessPath =
  TNilAccessPath() or
  TAccessPathConsNil(Content c)

/** An access path of length 0 or 1. */
class AccessPath extends TAccessPath {
  /** Gets the head of this access path, if any. */
  Content getHead() { this = TAccessPathConsNil(result) }

  /** Holds if this access path contains content `c`. */
  predicate contains(Content c) { this = TAccessPathConsNil(c) }

  /** Gets a textual representation of this access path. */
  string toString() {
    result = this.getHead().toString()
    or
    this = TNilAccessPath() and
    result = "<empty>"
  }
}

/** Provides predicates for constructing access paths. */
module AccessPath {
  /** Gets the empty access path. */
  AccessPath empty() { result = TNilAccessPath() }

  /** Gets a singleton property access path. */
  AccessPath property(Property p) {
    result = TAccessPathConsNil(any(PropertyContent c | c.getProperty() = p.getSourceDeclaration()))
  }
}

/** An unbound callable. */
class SourceDeclarationCallable extends Callable {
  SourceDeclarationCallable() { this = this.getSourceDeclaration() }
}

/** An unbound method. */
class SourceDeclarationMethod extends SourceDeclarationCallable, Method { }

private newtype TCallableFlowSource =
  TCallableFlowSourceQualifier() or
  TCallableFlowSourceArg(int i) { hasArgumentPosition(_, i) } or
  TCallableFlowSourceDelegateArg(int i) { hasDelegateArgumentPosition(_, i) }

private predicate hasArgumentPosition(SourceDeclarationCallable callable, int position) {
  exists(int arity |
    if callable.getAParameter().isParams()
    then
      arity =
        max(Call call |
          call.getTarget().getSourceDeclaration() = callable
        |
          call.getNumberOfArguments()
        )
    else arity = callable.getNumberOfParameters()
  |
    position in [0 .. arity - 1]
  )
}

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

  /**
   * Gets the type of the sink for call `c`. Unlike `getSink()`, this is defined
   * for all flow sink specifications.
   */
  Type getSinkType(Call c) { result = this.getSink(c).getType() }
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

  override Type getSinkType(Call c) { result = this.getArgument(c).getType() }
}

/** Gets the flow source for argument `i` of callable `callable`. */
private CallableFlowSourceArg getFlowSourceArg(SourceDeclarationCallable callable, int i) {
  i = result.getArgumentIndex() and
  hasArgumentPosition(callable, i)
}

/** Gets the flow source for argument `i` of delegate `callable`. */
private CallableFlowSourceDelegateArg getDelegateFlowSourceArg(
  SourceDeclarationCallable callable, int i
) {
  i = result.getArgumentIndex() and
  hasDelegateArgumentPosition(callable, i)
}

/** Gets the flow sink for the `j`th argument of the delegate at argument `i` of `callable`. */
private CallableFlowSinkDelegateArg getDelegateFlowSinkArg(
  SourceDeclarationCallable callable, int i, int j
) {
  result = TCallableFlowSinkDelegateArg(i, j) and
  hasDelegateArgumentPosition2(callable, i, j)
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

  override Type getSinkType(Call c) {
    result =
      c
          .getArgument(delegateIndex)
          .(DelegateArgumentToLibraryCallable)
          .getDelegateType()
          .getParameter(parameterIndex)
          .getType()
  }
}

/** A specification of data flow for a library (non-source code) type. */
abstract class LibraryTypeDataFlow extends Type {
  LibraryTypeDataFlow() { this = this.getSourceDeclaration() }

  /**
   * Holds if data may flow from `source` to `sink` when calling callable `c`.
   *
   * `preservesValue` indicates whether the value from `source` is preserved
   * (possibly copied) to `sink`. For example, the value is preserved from `x`
   * to `x.ToString()` when `x` is a `string`, but not from `x` to `x.ToLower()`.
   */
  pragma[nomagic]
  predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    none()
  }

  /**
   * Holds if data may flow from `source` to `sink` when calling callable `c`.
   *
   * `sourceAp` describes the contents of `source` that flows to `sink`
   * (if any), and `sinkContent` describes the contents of `sink` that it
   * flows to (if any).
   */
  pragma[nomagic]
  predicate callableFlow(
    CallableFlowSource source, AccessPath sourceAp, CallableFlowSink sink, AccessPath sinkAp,
    SourceDeclarationCallable c
  ) {
    none()
  }
}

/** Data flow for `System.Int32`. */
class SystemInt32Flow extends LibraryTypeDataFlow, SystemInt32Struct {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    methodFlow(source, sink, c) and
    preservesValue = false
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m = getParseMethod() and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn()
    or
    m = getTryParseMethod() and
    source = TCallableFlowSourceArg(0) and
    (
      sink = TCallableFlowSinkReturn()
      or
      sink = TCallableFlowSinkArg(any(int i | m.getParameter(i).isOutOrRef()))
    )
  }
}

/** Data flow for `System.Boolean`. */
class SystemBooleanFlow extends LibraryTypeDataFlow, SystemBooleanStruct {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    methodFlow(source, sink, c) and
    preservesValue = false
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m = getParseMethod() and
    (
      source = TCallableFlowSourceArg(0) and
      sink = TCallableFlowSinkReturn()
    )
    or
    m = getTryParseMethod() and
    (
      source = TCallableFlowSourceArg(0) and
      (
        sink = TCallableFlowSinkReturn()
        or
        sink = TCallableFlowSinkArg(any(int i | m.getParameter(i).isOutOrRef()))
      )
    )
  }
}

/** Data flow for `System.Uri`. */
class SystemUriFlow extends LibraryTypeDataFlow, SystemUriClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      constructorFlow(source, sink, c)
      or
      methodFlow(source, sink, c)
      or
      exists(Property p |
        propertyFlow(p) and
        source = TCallableFlowSourceQualifier() and
        sink = TCallableFlowSinkReturn() and
        c = p.getGetter()
      )
    ) and
    preservesValue = false
  }

  private predicate constructorFlow(CallableFlowSource source, CallableFlowSink sink, Constructor c) {
    c = getAMember() and
    c.getParameter(0).getType() instanceof StringType and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn()
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m.getDeclaringType() = getABaseType*() and
    m = any(SystemObjectClass c).getToStringMethod().getAnOverrider*() and
    source = TCallableFlowSourceQualifier() and
    sink = TCallableFlowSinkReturn()
  }

  private predicate propertyFlow(Property p) {
    p = getPathAndQueryProperty()
    or
    p = getQueryProperty()
    or
    p = getOriginalStringProperty()
  }
}

/** Data flow for `System.IO.StringReader`. */
class SystemIOStringReaderFlow extends LibraryTypeDataFlow, SystemIOStringReaderClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      constructorFlow(source, sink, c)
      or
      methodFlow(source, sink, c)
    ) and
    preservesValue = false
  }

  private predicate constructorFlow(CallableFlowSource source, CallableFlowSink sink, Constructor c) {
    c = getAMember() and
    c.getParameter(0).getType() instanceof StringType and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn()
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m.getDeclaringType() = getABaseType*() and
    m.getName().matches("Read%") and
    source = TCallableFlowSourceQualifier() and
    sink = TCallableFlowSinkReturn()
  }
}

/** Data flow for `System.String`. */
class SystemStringFlow extends LibraryTypeDataFlow, SystemStringClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    constructorFlow(source, sink, c) and preservesValue = false
    or
    methodFlow(source, sink, c, preservesValue)
  }

  private predicate constructorFlow(CallableFlowSource source, CallableFlowSink sink, Constructor c) {
    c = getAMember() and
    c.getParameter(0).getType().(ArrayType).getElementType() instanceof CharType and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn()
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m,
    boolean preservesValue
  ) {
    m = getAMethod() and
    (
      m = any(SystemObjectClass c).getToStringMethod().getAnOverrider*() and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      preservesValue = true
    )
    or
    m = getSplitMethod() and
    (
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
    or
    m = getReplaceMethod() and
    (
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
      or
      source = TCallableFlowSourceArg(1) and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
    or
    m = getSubstringMethod() and
    (
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
    or
    m = getCloneMethod() and
    (
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      preservesValue = true
    )
    or
    m = getInsertMethod() and
    (
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
      or
      source = TCallableFlowSourceArg(1) and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
    or
    m = getNormalizeMethod() and
    (
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
    or
    m = getRemoveMethod() and
    (
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
    or
    m = getAMethod() and
    (
      m
          .getName()
          .regexpMatch("((ToLower|ToUpper)(Invariant)?)|(Trim(Start|End)?)|(Pad(Left|Right))") and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
    or
    m = getConcatMethod() and
    (
      source = getFlowSourceArg(m, _) and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
    or
    m = getCopyMethod() and
    (
      source = TCallableFlowSourceArg(0) and
      sink = TCallableFlowSinkReturn() and
      preservesValue = true
    )
    or
    m = getJoinMethod() and
    (
      source = getFlowSourceArg(m, _) and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
    or
    m = getFormatMethod() and
    exists(int i |
      (m.getParameter(0).getType() instanceof SystemIFormatProviderInterface implies i != 0) and
      source = getFlowSourceArg(m, i) and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
  }
}

/** Data flow for `System.Text.StringBuilder`. */
class SystemTextStringBuilderFlow extends LibraryTypeDataFlow, SystemTextStringBuilderClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      constructorFlow(source, sink, c)
      or
      methodFlow(source, sink, c)
    ) and
    preservesValue = false
  }

  private predicate constructorFlow(CallableFlowSource source, CallableFlowSink sink, Constructor c) {
    c = getAMember() and
    c.getParameter(0).getType() instanceof StringType and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn()
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m.getDeclaringType() = getABaseType*() and
    (
      m = any(SystemObjectClass c).getToStringMethod().getAnOverrider*() and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn()
    )
    or
    m = getAMethod() and
    exists(int i, Type t |
      m.getName().regexpMatch("Append(Format|Line)?") and
      t = m.getParameter(i).getType() and
      source = getFlowSourceArg(m, i) and
      sink = TCallableFlowSinkQualifier()
    |
      t instanceof StringType or
      t instanceof ObjectType
    )
  }
}

/** Data flow for `System.Lazy<>`. */
class SystemLazyFlow extends LibraryTypeDataFlow, SystemLazyClass {
  override predicate callableFlow(
    CallableFlowSource source, AccessPath sourceAp, CallableFlowSink sink, AccessPath sinkAp,
    SourceDeclarationCallable c
  ) {
    exists(SystemFuncDelegateType t, int i | t.getNumberOfTypeParameters() = 1 |
      c.(Constructor).getDeclaringType() = this and
      c.getParameter(i).getType().getSourceDeclaration() = t and
      source = getDelegateFlowSourceArg(c, i) and
      sourceAp = AccessPath::empty() and
      sink = TCallableFlowSinkReturn() and
      sinkAp = AccessPath::property(this.getValueProperty())
    )
  }
}

/**
 * Data flow for `System.Collections.IEnumerable`, `System.Collections.Generic.IEnumerable<>`,
 * and their sub types (for example `System.Collections.Generic.List<>`).
 */
class IEnumerableFlow extends LibraryTypeDataFlow {
  IEnumerableFlow() {
    exists(RefType t | t = this.(RefType).getABaseType*() |
      t instanceof SystemCollectionsIEnumerableInterface
      or
      t instanceof SystemCollectionsGenericIEnumerableTInterface
      or
      t.(ConstructedInterface).getUnboundGeneric() instanceof
        SystemCollectionsGenericIEnumerableTInterface
    )
  }

  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      methodFlow(source, sink, c)
      or
      exists(Property p |
        propertyFlow(p) and
        source = TCallableFlowSourceQualifier() and
        sink = TCallableFlowSinkReturn() and
        c = p.getGetter()
      )
    ) and
    preservesValue = false
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    methodFlowLINQ(source, sink, m)
    or
    methodFlowSpecific(source, sink, m)
  }

  /** Flow for LINQ methods. */
  private predicate methodFlowLINQ(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m.(ExtensionMethod).getExtendedType().getSourceDeclaration() = this and
    exists(string name, int arity | name = m.getName() and arity = m.getNumberOfParameters() |
      name = "Aggregate" and
      (
        arity = 2 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 1)
          or
          source = TCallableFlowSourceDelegateArg(1) and
          sink = TCallableFlowSinkReturn()
        )
        or
        arity = 3 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 2, 1)
          or
          source = TCallableFlowSourceArg(1) and
          sink = getDelegateFlowSinkArg(m, 2, 0)
          or
          source = TCallableFlowSourceDelegateArg(2) and
          sink = TCallableFlowSinkReturn()
        )
        or
        arity = 4 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 2, 1)
          or
          source = TCallableFlowSourceArg(1) and
          sink = getDelegateFlowSinkArg(m, 2, 0)
          or
          source = TCallableFlowSourceDelegateArg(2) and
          sink = getDelegateFlowSinkArg(m, 3, 0)
          or
          source = TCallableFlowSourceDelegateArg(3) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name = "All" and
      (
        arity = 2 and
        source = TCallableFlowSourceArg(0) and
        sink = getDelegateFlowSinkArg(m, 1, 0)
      )
      or
      name = "Any" and
      (
        arity = 2 and
        source = TCallableFlowSourceArg(0) and
        sink = getDelegateFlowSinkArg(m, 1, 0)
      )
      or
      name = "AsEnumerable" and
      (
        arity = 1 and
        source = TCallableFlowSourceArg(0) and
        sink = TCallableFlowSinkReturn()
      )
      or
      name = "AsQueryable" and
      arity = 1 and
      source = TCallableFlowSourceArg(0) and
      sink = TCallableFlowSinkReturn()
      or
      name = "Average" and
      (
        arity = 2 and
        source = TCallableFlowSourceArg(0) and
        sink = getDelegateFlowSinkArg(m, 1, 0)
      )
      or
      name = "Cast" and
      (
        arity = 1 and
        source = TCallableFlowSourceArg(0) and
        sink = TCallableFlowSinkReturn()
      )
      or
      name = "Concat" and
      (
        arity = 2 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
          or
          source = TCallableFlowSourceArg(1) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name.regexpMatch("(Long)?Count") and
      (
        arity = 2 and
        source = TCallableFlowSourceArg(0) and
        sink = getDelegateFlowSinkArg(m, 1, 0)
      )
      or
      name = "DefaultIfEmpty" and
      (
        arity in [1 .. 2] and
        source = TCallableFlowSourceArg(0) and
        sink = TCallableFlowSinkReturn()
        or
        arity = 2 and
        source = TCallableFlowSourceArg(1) and
        sink = TCallableFlowSinkReturn()
      )
      or
      name = "Distinct" and
      (
        arity in [1 .. 2] and
        source = TCallableFlowSourceArg(0) and
        sink = TCallableFlowSinkReturn()
      )
      or
      name.regexpMatch("ElementAt(OrDefault)?") and
      (
        arity = 2 and
        source = TCallableFlowSourceArg(0) and
        sink = TCallableFlowSinkReturn()
      )
      or
      name = "Except" and
      (
        arity in [2 .. 3] and
        source = TCallableFlowSourceArg(0) and
        sink = TCallableFlowSinkReturn()
      )
      or
      name.regexpMatch("(First|Single)(OrDefault)?") and
      (
        arity in [1 .. 2] and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
        )
        or
        arity = 2 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
        )
      )
      or
      name = "GroupBy" and
      (
        arity = 3 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
          or
          m.getParameter(2).getType().(ConstructedDelegateType).getNumberOfTypeArguments() = 2 and
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 2, 0)
          or
          m.getParameter(2).getType().(ConstructedDelegateType).getNumberOfTypeArguments() = 3 and
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 2, 1)
          or
          m.getParameter(2).getType().(ConstructedDelegateType).getNumberOfTypeArguments() = 3 and
          source = getDelegateFlowSourceArg(m, 1) and
          sink = getDelegateFlowSinkArg(m, 2, 0)
          or
          not m.getParameter(2).getType().getSourceDeclaration() instanceof
            SystemCollectionsGenericIEqualityComparerTInterface and
          source = getDelegateFlowSourceArg(m, 2) and
          sink = TCallableFlowSinkReturn()
          or
          m.getParameter(2).getType().getSourceDeclaration() instanceof
            SystemCollectionsGenericIEqualityComparerTInterface and
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
        )
        or
        arity in [4 .. 5] and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
          or
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 2, 0)
          or
          source = getDelegateFlowSourceArg(m, 1) and
          sink = getDelegateFlowSinkArg(m, 3, 0)
          or
          source = getDelegateFlowSourceArg(m, 2) and
          sink = getDelegateFlowSinkArg(m, 3, 1)
          or
          source = getDelegateFlowSourceArg(m, 3) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name.regexpMatch("(Group)?Join") and
      (
        arity in [5 .. 6] and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 2, 0)
          or
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 4, 0)
          or
          source = TCallableFlowSourceArg(1) and
          sink = getDelegateFlowSinkArg(m, 3, 0)
          or
          source = TCallableFlowSourceArg(1) and
          sink = getDelegateFlowSinkArg(m, 4, 1)
          or
          source = TCallableFlowSourceDelegateArg(4) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name = "Intersect" and
      (
        arity in [2 .. 3] and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
          or
          source = TCallableFlowSourceArg(1) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name.regexpMatch("Last(OrDefault)?") and
      (
        arity in [1 .. 2] and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
        )
        or
        arity = 2 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
        )
      )
      or
      name.regexpMatch("Max|Min|Sum") and
      (
        arity = 2 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
        )
      )
      or
      name = "OfType" and
      (
        arity = 1 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name.regexpMatch("OrderBy(Descending)?") and
      (
        arity in [2 .. 3] and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
          or
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
        )
      )
      or
      name = "Repeat" and
      (
        arity = 2 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name = "Reverse" and
      (
        arity = 1 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name.regexpMatch("Select(Many)?") and
      (
        arity = 2 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
          or
          source = TCallableFlowSourceDelegateArg(1) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name = "SelectMany" and
      (
        arity = 3 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
          or
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 2, 0)
          or
          source = TCallableFlowSourceDelegateArg(1) and
          sink = getDelegateFlowSinkArg(m, 2, 1)
          or
          source = TCallableFlowSourceDelegateArg(2) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name.regexpMatch("(Skip|Take)(While)?") and
      (
        arity = 2 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name.regexpMatch("(Skip|Take)While") and
      (
        arity = 2 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
        )
      )
      or
      name.regexpMatch("ThenBy(Descending)?") and
      (
        arity in [2 .. 3] and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
          or
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name.regexpMatch("To(Array|List)") and
      (
        arity = 1 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name.regexpMatch("To(Dictionary|Lookup)") and
      (
        arity in [2 .. 3] and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
          or
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn() and
          not m.getParameter(2).getType() instanceof DelegateType
        )
        or
        arity in [3 .. 4] and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
          or
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 2, 0)
          or
          source = getDelegateFlowSourceArg(m, 2) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name = "Union" and
      (
        arity in [2 .. 3] and
        (
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
          or
          source = TCallableFlowSourceArg(1) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name = "Where" and
      (
        arity = 2 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 1, 0)
          or
          source = TCallableFlowSourceArg(0) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      name = "Zip" and
      (
        arity = 3 and
        (
          source = TCallableFlowSourceArg(0) and
          sink = getDelegateFlowSinkArg(m, 2, 0)
          or
          source = TCallableFlowSourceArg(1) and
          sink = getDelegateFlowSinkArg(m, 2, 1)
          or
          source = getDelegateFlowSourceArg(m, 2) and
          sink = TCallableFlowSinkReturn()
        )
      )
    )
  }

  /** Flow for specific enumerables (e.g., `List<T>` and `Stack<T>`). */
  private predicate methodFlowSpecific(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m = getFind() and
    if m.isStatic()
    then
      source = TCallableFlowSourceArg(0) and
      (
        sink = TCallableFlowSinkReturn() or
        sink = getDelegateFlowSinkArg(m, 1, 0)
      )
    else (
      source = TCallableFlowSourceQualifier() and
      (
        sink = TCallableFlowSinkReturn() or
        sink = getDelegateFlowSinkArg(m, 0, 0)
      )
    )
    or
    exists(string name, int arity |
      name = m.getName() and
      arity = m.getNumberOfParameters() and
      m.getDeclaringType() = this.(RefType).getABaseType*()
    |
      name = "FixedSize" and
      (
        source = TCallableFlowSourceArg(0) and
        sink = TCallableFlowSinkReturn()
      )
      or
      name
          .regexpMatch("GetByIndex|Peek|Pop|AsReadOnly|Clone|GetRange|MemberwiseClone|Reverse|GetEnumerator|GetValueList") and
      (
        source = TCallableFlowSourceQualifier() and
        sink = TCallableFlowSinkReturn()
      )
      or
      name.regexpMatch("Add(Range)?") and
      (
        arity = 1 and
        source = TCallableFlowSourceArg(0) and
        sink = TCallableFlowSinkQualifier()
      )
      or
      name = "Add" and
      (
        arity = 2 and
        source = TCallableFlowSourceArg(1) and
        sink = TCallableFlowSinkQualifier()
      )
      or
      name.regexpMatch("Insert(Range)?") and
      (
        not this instanceof StringType and
        arity = 2 and
        source = TCallableFlowSourceArg(1) and
        sink = TCallableFlowSinkQualifier()
      )
    )
  }

  private SourceDeclarationMethod getFind() {
    exists(string name |
      name = result.getName() and
      result.getDeclaringType() = this.(RefType).getABaseType*()
    |
      name.regexpMatch("Find(All|Last)?")
    )
  }

  private predicate propertyFlow(Property p) {
    this.(RefType).getABaseType*() = p.getDeclaringType() and
    p.hasName("Values")
  }
}

/** Data flow for `System.Convert`. */
class SystemConvertFlow extends LibraryTypeDataFlow, SystemConvertClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    methodFlow(source, sink, c) and
    preservesValue = false
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m = getAMethod() and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn()
  }
}

/**
 * Data flow for WCF data contracts.
 *
 * Flow is defined from a WCF data contract object to any of its data member
 * properties. This flow model only makes sense from a taint-tracking perspective
 * (a tainted data contract object implies tainted data members).
 */
class DataContractFlow extends LibraryTypeDataFlow, DataContractClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    exists(Property p |
      propertyFlow(p) and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      c = p.getGetter()
    ) and
    preservesValue = false
  }

  private predicate propertyFlow(Property p) {
    p.getDeclaringType() = this and
    p.getAnAttribute() instanceof DataMemberAttribute
  }
}

/** Data flow for `System.Web.HttpCookie`. */
class SystemWebHttpCookieFlow extends LibraryTypeDataFlow, SystemWebHttpCookie {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    exists(Property p |
      propertyFlow(p) and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      c = p.getGetter()
    ) and
    preservesValue = false
  }

  private predicate propertyFlow(Property p) {
    p = getValueProperty() or
    p = getValuesProperty()
  }
}

/** Data flow for `System.Net.Cookie`. */
class SystemNetCookieFlow extends LibraryTypeDataFlow, SystemNetCookieClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    exists(Property p |
      propertyFlow(p) and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      c = p.getGetter()
    ) and
    preservesValue = false
  }

  private predicate propertyFlow(Property p) { p = this.getValueProperty() }
}

/** Data flow for `System.Net.IPHostEntry`. */
class SystemNetIPHostEntryFlow extends LibraryTypeDataFlow, SystemNetIPHostEntryClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    exists(Property p |
      propertyFlow(p) and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      c = p.getGetter()
    ) and
    preservesValue = false
  }

  private predicate propertyFlow(Property p) {
    p = getHostNameProperty() or
    p = getAliasesProperty()
  }
}

/** Data flow for `System.Web.UI.WebControls.TextBox`. */
class SystemWebUIWebControlsTextBoxFlow extends LibraryTypeDataFlow,
  SystemWebUIWebControlsTextBoxClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    exists(Property p |
      propertyFlow(p) and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      c = p.getGetter()
    ) and
    preservesValue = false
  }

  private predicate propertyFlow(Property p) { p = getTextProperty() }
}

/**
 * Data flow for `System.Collections.Generic.KeyValuePair`.
 *
 * Flow is only considered for the value (not the key).
 */
class SystemCollectionsGenericKeyValuePairStructFlow extends LibraryTypeDataFlow {
  SystemCollectionsGenericKeyValuePairStructFlow() {
    this instanceof SystemCollectionsGenericKeyValuePairStruct
  }

  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      constructorFlow(source, sink, c)
      or
      exists(Property p |
        propertyFlow(p) and
        source = TCallableFlowSourceQualifier() and
        sink = TCallableFlowSinkReturn() and
        c = p.getGetter()
      )
    ) and
    preservesValue = true
  }

  private predicate constructorFlow(CallableFlowSource source, CallableFlowSink sink, Constructor c) {
    c.getDeclaringType() = this and
    source = getFlowSourceArg(c, 1) and
    sink = TCallableFlowSinkReturn()
  }

  private predicate propertyFlow(Property p) {
    p = this.(SystemCollectionsGenericKeyValuePairStruct).getValueProperty()
  }
}

/** Data flow for `System.Collections.Generic.IEnumerator`. */
class SystemCollectionsGenericIEnumeratorInterfaceFlow extends LibraryTypeDataFlow {
  SystemCollectionsGenericIEnumeratorInterfaceFlow() {
    this instanceof SystemCollectionsGenericIEnumeratorInterface
  }

  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    exists(Property p |
      propertyFlow(p) and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      c = p.getGetter()
    ) and
    preservesValue = true
  }

  private predicate propertyFlow(Property p) {
    p = this.(SystemCollectionsGenericIEnumeratorInterface).getCurrentProperty()
  }
}

/** Data flow for `System.Collections.IEnumerator`. */
class SystemCollectionsIEnumeratorInterfaceFlow extends LibraryTypeDataFlow,
  SystemCollectionsIEnumeratorInterface {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    exists(Property p |
      propertyFlow(p) and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn() and
      c = p.getGetter()
    ) and
    preservesValue = true
  }

  private predicate propertyFlow(Property p) { p = getCurrentProperty() }
}

/** Data flow for `System.Threading.Tasks.Task`. */
class SystemThreadingTasksTaskFlow extends LibraryTypeDataFlow, SystemThreadingTasksTaskClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      constructorFlow(source, sink, c)
      or
      methodFlow(source, sink, c)
    ) and
    preservesValue = true
  }

  private predicate constructorFlow(CallableFlowSource source, CallableFlowSink sink, Constructor c) {
    // flow from supplied state to supplied delegate
    c.getDeclaringType() = this and
    exists(ConstructedDelegateType action |
      c.getParameter(1).getType() instanceof ObjectType and
      c.getParameter(0).getType() = action and
      action.getUnboundGeneric().(SystemActionTDelegateType).getNumberOfTypeParameters() = 1 and
      action.getTypeArgument(0) instanceof ObjectType and
      source = TCallableFlowSourceArg(1) and
      sink = getDelegateFlowSinkArg(c, 0, 0)
    )
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m.getDeclaringType() = this and
    (
      m.hasName("ContinueWith") and
      (
        // flow from supplied state to supplied delegate
        exists(ConstructedDelegateType delegate, int i, int j, int k |
          m.getParameter(i).getType() instanceof ObjectType and
          m.getParameter(j).getType() = delegate and
          (
            delegate.getUnboundGeneric() instanceof SystemActionTDelegateType or
            delegate.getUnboundGeneric() instanceof SystemFuncDelegateType
          ) and
          delegate.getTypeArgument(k) instanceof ObjectType and
          source = TCallableFlowSourceArg(i) and
          sink = getDelegateFlowSinkArg(m, j, k)
        )
        or
        // flow out of supplied function
        exists(ConstructedDelegateType func, int i |
          m.getParameter(i).getType() = func and
          func.getUnboundGeneric() instanceof SystemFuncDelegateType and
          source = getDelegateFlowSourceArg(m, i) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      m.hasName("FromResult") and
      (
        source = TCallableFlowSourceArg(0) and
        sink = TCallableFlowSinkReturn()
      )
      or
      m.hasName("Run") and
      (
        m.getReturnType() = any(SystemThreadingTasksTaskTClass c).getAConstructedGeneric() and
        m.(UnboundGenericMethod).getNumberOfTypeParameters() = 1 and
        source = TCallableFlowSourceDelegateArg(0) and
        sink = TCallableFlowSinkReturn()
      )
      or
      m.getName().regexpMatch("WhenAll|WhenAny") and
      (
        m.getReturnType() = any(SystemThreadingTasksTaskTClass c).getAConstructedGeneric() and
        m.(UnboundGenericMethod).getNumberOfTypeParameters() = 1 and
        source = getFlowSourceArg(m, _) and
        sink = TCallableFlowSinkReturn()
      )
    )
  }
}

/** Data flow for `System.Threading.Tasks.Task<>`. */
class SystemThreadingTasksTaskTFlow extends LibraryTypeDataFlow {
  SystemThreadingTasksTaskTFlow() { this instanceof SystemThreadingTasksTaskTClass }

  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      constructorFlow(source, sink, c)
      or
      methodFlow(source, sink, c)
      or
      exists(Property p |
        propertyFlow(p) and
        source = TCallableFlowSourceQualifier() and
        sink = TCallableFlowSinkReturn() and
        c = p.getGetter()
      )
    ) and
    preservesValue = true
  }

  private predicate constructorFlow(CallableFlowSource source, CallableFlowSink sink, Constructor c) {
    // flow from supplied function into constructed Task
    c.getDeclaringType() = this and
    (
      c.getParameter(0).getType() = any(SystemFuncDelegateType t).getAConstructedGeneric() and
      source = TCallableFlowSourceDelegateArg(0) and
      sink = TCallableFlowSinkReturn()
    )
    or
    // flow from supplied state to supplied delegate
    c.getDeclaringType() = this and
    exists(ConstructedDelegateType func |
      c.getParameter(1).getType() instanceof ObjectType and
      c.getParameter(0).getType() = func and
      func.getUnboundGeneric().(SystemFuncDelegateType).getNumberOfTypeParameters() = 2 and
      func.getTypeArgument(0) instanceof ObjectType and
      source = TCallableFlowSourceArg(1) and
      sink = getDelegateFlowSinkArg(c, 0, 0)
    )
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m.getDeclaringType() = this and
    m.hasName("ContinueWith") and
    (
      exists(ConstructedDelegateType delegate, int i, int j |
        m.getParameter(i).getType() = delegate and
        (
          delegate.getUnboundGeneric() instanceof SystemActionTDelegateType or
          delegate.getUnboundGeneric() instanceof SystemFuncDelegateType
        )
      |
        // flow from supplied state to supplied delegate
        exists(int k |
          delegate.getTypeArgument(j) instanceof ObjectType and
          m.getParameter(k).getType() instanceof ObjectType and
          source = TCallableFlowSourceArg(k) and
          sink = getDelegateFlowSinkArg(m, i, j)
        )
        or
        // flow from this task to supplied delegate
        delegate.getTypeArgument(j) = this and
        source = TCallableFlowSourceQualifier() and
        sink = getDelegateFlowSinkArg(m, i, j)
      )
      or
      // flow out of supplied function
      exists(ConstructedDelegateType func, int i |
        m.getParameter(i).getType() = func and
        func.getUnboundGeneric() instanceof SystemFuncDelegateType and
        source = getDelegateFlowSourceArg(m, i) and
        sink = TCallableFlowSinkReturn()
      )
    )
  }

  private predicate propertyFlow(Property p) {
    p = this.(SystemThreadingTasksTaskTClass).getResultProperty()
  }
}

/** Data flow for `System.Threading.Tasks.TaskFactory`(`<TResult>`). */
class SystemThreadingTasksFactoryFlow extends LibraryTypeDataFlow {
  SystemThreadingTasksFactoryFlow() {
    this instanceof SystemThreadingTasksClass and
    getName().regexpMatch("TaskFactory(<>)?")
  }

  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    methodFlow(source, sink, c) and
    preservesValue = true
  }

  private predicate methodFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationMethod m
  ) {
    m.getDeclaringType() = this and
    (
      m.getName().regexpMatch("ContinueWhen(All|Any)") and
      (
        // flow into supplied function
        exists(ConstructedDelegateType delegate, ArrayType at, int i, int j, int k |
          at = m.getParameter(i).getType() and
          at.getElementType() = any(SystemThreadingTasksTaskTClass c).getAConstructedGeneric() and
          (at = delegate.getTypeArgument(k) or at.getElementType() = delegate.getTypeArgument(k)) and
          m.getParameter(j).getType() = delegate and
          (
            delegate.getUnboundGeneric() instanceof SystemActionTDelegateType or
            delegate.getUnboundGeneric() instanceof SystemFuncDelegateType
          ) and
          source = TCallableFlowSourceArg(i) and
          sink = getDelegateFlowSinkArg(m, j, k)
        )
        or
        // flow out of supplied function
        exists(ConstructedDelegateType func, int i |
          m.getParameter(i).getType() = func and
          func.getUnboundGeneric() instanceof SystemFuncDelegateType and
          source = getDelegateFlowSourceArg(m, i) and
          sink = TCallableFlowSinkReturn()
        )
      )
      or
      m.hasName("StartNew") and
      (
        // flow from supplied state to supplied delegate
        exists(ConstructedDelegateType delegate, int i, int j, int k |
          m.getParameter(i).getType() instanceof ObjectType and
          m.getParameter(j).getType() = delegate and
          (
            delegate.getUnboundGeneric() instanceof SystemActionTDelegateType or
            delegate.getUnboundGeneric() instanceof SystemFuncDelegateType
          ) and
          delegate.getTypeArgument(k) instanceof ObjectType and
          source = TCallableFlowSourceArg(i) and
          sink = getDelegateFlowSinkArg(m, j, k)
        )
        or
        // flow out of supplied function
        exists(ConstructedDelegateType func, int i |
          m.getParameter(i).getType() = func and
          func.getUnboundGeneric() instanceof SystemFuncDelegateType and
          source = getDelegateFlowSourceArg(m, i) and
          sink = TCallableFlowSinkReturn()
        )
      )
    )
  }
}

/** Data flow for `System.Text.Encoding`. */
library class SystemTextEncodingFlow extends LibraryTypeDataFlow, SystemTextEncodingClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (c = getGetBytesMethod() or c = getGetStringMethod() or c = getGetCharsMethod()) and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn() and
    preservesValue = false
  }
}

/** Data flow for `System.IO.MemoryStream`. */
library class SystemIOMemoryStreamFlow extends LibraryTypeDataFlow, SystemIOMemoryStreamClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      constructorFlow(source, sink, c)
      or
      c = getToArrayMethod().getAnOverrider*() and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn()
    ) and
    preservesValue = false
  }

  private predicate constructorFlow(CallableFlowSource source, CallableFlowSink sink, Constructor c) {
    c = getAMember() and
    c.getParameter(0).getType().(ArrayType).getElementType() instanceof ByteType and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn()
  }
}

/** Data flow for `System.IO.Stream`. */
class SystemIOStreamFlow extends LibraryTypeDataFlow, SystemIOStreamClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      c = getAReadMethod().getAnOverrider*() and
      c.getParameter(0).getType().(ArrayType).getElementType() instanceof ByteType and
      sink = TCallableFlowSinkArg(0) and
      source = TCallableFlowSourceQualifier()
      or
      c = getAWriteMethod().getAnOverrider*() and
      c.getParameter(0).getType().(ArrayType).getElementType() instanceof ByteType and
      source = TCallableFlowSourceArg(0) and
      sink = TCallableFlowSinkQualifier()
      or
      c = any(Method m | m = getAMethod() and m.getName().matches("CopyTo%")).getAnOverrider*() and
      c.getParameter(0).getType() instanceof SystemIOStreamClass and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkArg(0)
    ) and
    preservesValue = false
  }
}

/** Data flow for `System.IO.Compression.DeflateStream`. */
class SystemIOCompressionDeflateStreamFlow extends LibraryTypeDataFlow,
  SystemIOCompressionDeflateStream {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    constructorFlow(source, sink, c) and
    preservesValue = false
  }

  private predicate constructorFlow(CallableFlowSource source, CallableFlowSink sink, Constructor c) {
    c = getAMember() and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn()
  }
}

/** Data flow for `System.Xml.XmlReader`. */
class SystemXmlXmlReaderFlow extends LibraryTypeDataFlow, SystemXmlXmlReaderClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    c = getCreateMethod() and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn() and
    preservesValue = false
  }
}

/** Data flow for `System.Xml.XmlDocument`. */
class SystemXmlXmlDocumentFlow extends LibraryTypeDataFlow, SystemXmlXmlDocumentClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    c = getLoadMethod() and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkQualifier() and
    preservesValue = false
  }
}

/** Data flow for `System.Xml.XmlNode`. */
class SystemXmlXmlNodeFlow extends LibraryTypeDataFlow, SystemXmlXmlNodeClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      exists(Property p |
        p = getAProperty() and
        c = p.getGetter() and
        source = TCallableFlowSourceQualifier() and
        sink = TCallableFlowSinkReturn()
      )
      or
      c = getASelectNodeMethod() and
      source = TCallableFlowSourceQualifier() and
      sink = TCallableFlowSinkReturn()
    ) and
    preservesValue = false
  }
}

/** Data flow for `System.Xml.XmlNamedNodeMap`. */
class SystemXmlXmlNamedNodeMapFlow extends LibraryTypeDataFlow, SystemXmlXmlNamedNodeMapClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    c = getGetNamedItemMethod() and
    source = TCallableFlowSourceQualifier() and
    sink = TCallableFlowSinkReturn() and
    preservesValue = true
  }
}

/** Data flow for `System.IO.Path`. */
class SystemIOPathFlow extends LibraryTypeDataFlow, SystemIOPathClass {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    c = getAMethod("Combine") and
    source = getFlowSourceArg(c, _) and
    sink = TCallableFlowSinkReturn() and
    preservesValue = false
    or
    exists(Parameter p |
      c = getAMethod() and
      c.getName().matches("Get%") and
      p = c.getAParameter() and
      p.hasName("path") and
      source = getFlowSourceArg(c, p.getPosition()) and
      sink = TCallableFlowSinkReturn() and
      preservesValue = false
    )
  }
}

/** Data flow for `System.Web.HttpUtility`. */
class SystemWebHttpUtilityFlow extends LibraryTypeDataFlow, SystemWebHttpUtility {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      c = getAnHtmlAttributeEncodeMethod() or
      c = getAnHtmlEncodeMethod() or
      c = getAJavaScriptStringEncodeMethod() or
      c = getAnUrlEncodeMethod()
    ) and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn() and
    preservesValue = false
  }
}

/** Data flow for `System.Web.HttpServerUtility`. */
class SystemWebHttpServerUtilityFlow extends LibraryTypeDataFlow, SystemWebHttpServerUtility {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      c = getAnHtmlEncodeMethod() or
      c = getAnUrlEncodeMethod()
    ) and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn() and
    preservesValue = false
  }
}

/** Data flow for `System.Net.WebUtility`. */
class SystemNetWebUtilityFlow extends LibraryTypeDataFlow, SystemNetWebUtility {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    (
      c = getAnHtmlEncodeMethod() or
      c = getAnUrlEncodeMethod()
    ) and
    source = TCallableFlowSourceArg(0) and
    sink = TCallableFlowSinkReturn() and
    preservesValue = false
  }
}

/**
 * The `StringValues` class used in many .NET Core libraries. Requires special `LibraryTypeDataFlow` flow.
 */
class StringValues extends Struct {
  StringValues() { this.hasQualifiedName("Microsoft.Extensions.Primitives", "StringValues") }
}

/**
 * Custom flow through StringValues.StringValues library class
 */
class StringValuesFlow extends LibraryTypeDataFlow, StringValues {
  override predicate callableFlow(
    CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
    boolean preservesValue
  ) {
    c = any(Callable ca | this = ca.getDeclaringType()) and
    (
      source = any(CallableFlowSourceArg a) or
      source = any(CallableFlowSourceQualifier q)
    ) and
    sink = any(CallableFlowSinkReturn r) and
    preservesValue = false
  }
}
