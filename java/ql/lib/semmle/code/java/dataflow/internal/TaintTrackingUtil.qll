private import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.Collections
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dataflow.DefUse
private import semmle.code.java.security.SecurityTests
private import semmle.code.java.security.Validation
private import semmle.code.java.Maps
private import semmle.code.java.dataflow.internal.ContainerFlow
private import semmle.code.java.frameworks.spring.SpringController
private import semmle.code.java.frameworks.spring.SpringHttp
private import semmle.code.java.frameworks.Networking
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.internal.DataFlowPrivate
import semmle.code.java.dataflow.FlowSteps
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.java.frameworks.JaxWS

/**
 * Holds if taint can flow from `src` to `sink` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localTaint(DataFlow::Node src, DataFlow::Node sink) { localTaintStep*(src, sink) }

/**
 * Holds if taint can flow from `src` to `sink` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprTaint(Expr src, Expr sink) {
  localTaint(DataFlow::exprNode(src), DataFlow::exprNode(sink))
}

cached
private module Cached {
  private import DataFlowImplCommon as DataFlowImplCommon

  cached
  predicate forceCachingInSameStage() { DataFlowImplCommon::forceCachingInSameStage() }

  /**
   * Holds if taint can flow in one local step from `src` to `sink`.
   */
  cached
  predicate localTaintStep(DataFlow::Node src, DataFlow::Node sink) {
    DataFlow::localFlowStep(src, sink)
    or
    localAdditionalTaintStep(src, sink)
    or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    FlowSummaryImpl::Private::Steps::summaryThroughStep(src, sink, false)
    or
    // Treat container flow as taint for the local taint flow relation
    exists(DataFlow::Content c | containerContent(c) |
      readStep(src, c, sink) or
      storeStep(src, c, sink) or
      FlowSummaryImpl::Private::Steps::summaryGetterStep(src, c, sink) or
      FlowSummaryImpl::Private::Steps::summarySetterStep(src, c, sink)
    )
  }

  /**
   * Holds if taint can flow in one local step from `src` to `sink` excluding
   * local data flow steps. That is, `src` and `sink` are likely to represent
   * different objects.
   */
  cached
  predicate localAdditionalTaintStep(DataFlow::Node src, DataFlow::Node sink) {
    localAdditionalTaintExprStep(src.asExpr(), sink.asExpr())
    or
    localAdditionalTaintUpdateStep(src.asExpr(),
      sink.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr())
    or
    exists(DataFlow::Content f |
      readStep(src, f, sink) and
      not sink.getTypeBound() instanceof PrimitiveType and
      not sink.getTypeBound() instanceof BoxedType and
      not sink.getTypeBound() instanceof NumberType and
      (
        containerContent(f)
        or
        f instanceof TaintInheritingContent
      )
    )
    or
    FlowSummaryImpl::Private::Steps::summaryLocalStep(src, sink, false)
  }

  /**
   * Holds if the additional step from `src` to `sink` should be included in all
   * global taint flow configurations.
   */
  cached
  predicate defaultAdditionalTaintStep(DataFlow::Node src, DataFlow::Node sink) {
    localAdditionalTaintStep(src, sink) or
    entrypointFieldStep(src, sink) or
    any(AdditionalTaintStep a).step(src, sink)
  }

  /**
   * Holds if `node` should be a sanitizer in all global taint flow configurations
   * but not in local taint.
   */
  cached
  predicate defaultTaintSanitizer(DataFlow::Node node) {
    // Ignore paths through test code.
    node.getEnclosingCallable().getDeclaringType() instanceof NonSecurityTestClass or
    node.asExpr() instanceof ValidatedVariableAccess
  }
}

/**
 * Holds if `guard` should be a sanitizer guard in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizerGuard(DataFlow::BarrierGuard guard) { none() }

import Cached

private RefType getElementType(RefType container) {
  result = container.(Array).getComponentType() or
  result = container.(CollectionType).getElementType() or
  result = container.(MapType).getValueType()
}

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::Content c) {
  exists(RefType container |
    (node.asExpr() instanceof Argument or node instanceof ArgumentNode) and
    getElementType*(node.getType()) = container
  |
    container instanceof Array and
    c instanceof DataFlow::ArrayContent
    or
    container instanceof CollectionType and
    c instanceof DataFlow::CollectionContent
    or
    container instanceof MapType and
    c instanceof DataFlow::MapValueContent
  )
}

/**
 * Holds if taint can flow in one local step from `src` to `sink` excluding
 * local data flow steps. That is, `src` and `sink` are likely to represent
 * different objects.
 */
private predicate localAdditionalTaintExprStep(Expr src, Expr sink) {
  sink.(AddExpr).getAnOperand() = src and sink.getType() instanceof TypeString
  or
  sink.(AssignAddExpr).getSource() = src and sink.getType() instanceof TypeString
  or
  sink.(LogicExpr).getAnOperand() = src
  or
  constructorStep(src, sink)
  or
  qualifierToMethodStep(src, sink)
  or
  argToMethodStep(src, sink)
  or
  comparisonStep(src, sink)
  or
  serializationStep(src, sink)
  or
  formatStep(src, sink)
}

/**
 * Holds if taint can flow in one local step from `src` to `sink` excluding
 * local data flow steps. That is, `src` and `sink` are likely to represent
 * different objects.
 * This is restricted to cases where the step updates the value of `sink`.
 */
private predicate localAdditionalTaintUpdateStep(Expr src, Expr sink) {
  qualifierToArgumentStep(src, sink)
  or
  argToArgStep(src, sink)
  or
  argToQualifierStep(src, sink)
}

private class BulkData extends RefType {
  BulkData() {
    this.(Array).getElementType().(PrimitiveType).getName().regexpMatch("byte|char")
    or
    exists(RefType t | this.getASourceSupertype*() = t |
      t.hasQualifiedName("java.io", "InputStream") or
      t.hasQualifiedName("java.nio", "ByteBuffer") or
      t.hasQualifiedName("java.lang", "Readable") or
      t.hasQualifiedName("java.io", "DataInput") or
      t.hasQualifiedName("java.nio.channels", "ReadableByteChannel")
    )
  }
}

/**
 * Holds if `c` is a constructor for a subclass of `java.io.InputStream` that
 * wraps an underlying data source. The underlying data source is given as a
 * the `argi`'th parameter to the constructor.
 *
 * An object construction of such a wrapper is likely to preserve the data flow
 * status of its argument.
 */
private predicate inputStreamWrapper(Constructor c, int argi) {
  c.getParameterType(argi) instanceof BulkData and
  c.getDeclaringType().getASourceSupertype().hasQualifiedName("java.io", "InputStream")
}

/** An object construction that preserves the data flow status of any of its arguments. */
private predicate constructorStep(Expr tracked, ConstructorCall sink) {
  exists(int argi | sink.getArgument(argi) = tracked |
    // wrappers constructed by extension
    exists(Constructor c, Parameter p, SuperConstructorInvocationStmt sup |
      c = sink.getConstructor() and
      p = c.getParameter(argi) and
      sup.getEnclosingCallable() = c and
      constructorStep(p.getAnAccess(), sup)
    )
    or
    // a custom InputStream that wraps a tainted data source is tainted
    inputStreamWrapper(sink.getConstructor(), argi)
    or
    sink.getConstructor().(TaintPreservingCallable).returnsTaintFrom(argToParam(sink, argi))
  )
}

/**
 * Converts an argument index to a formal parameter index.
 * This is relevant for varadic methods.
 */
private int argToParam(Call call, int arg) {
  exists(call.getArgument(arg)) and
  exists(Callable c | c = call.getCallee() |
    if c.isVarargs() and arg >= c.getNumberOfParameters()
    then result = c.getNumberOfParameters() - 1
    else result = arg
  )
}

/** Access to a method that passes taint from qualifier to argument. */
private predicate qualifierToArgumentStep(Expr tracked, Expr sink) {
  exists(MethodAccess ma, int arg |
    ma.getMethod().(TaintPreservingCallable).transfersTaint(-1, argToParam(ma, arg)) and
    tracked = ma.getQualifier() and
    sink = ma.getArgument(arg)
  )
}

/** Access to a method that passes taint from the qualifier. */
private predicate qualifierToMethodStep(Expr tracked, MethodAccess sink) {
  (taintPreservingQualifierToMethod(sink.getMethod()) or unsafeEscape(sink)) and
  tracked = sink.getQualifier()
}

/**
 * Methods that return tainted data when called on tainted data.
 */
private predicate taintPreservingQualifierToMethod(Method m) {
  m instanceof CloneMethod
  or
  m.getDeclaringType().getQualifiedName().matches("%StringWriter") and
  (
    m.getName() = "getBuffer"
    or
    m.getName() = "toString"
  )
  or
  m.getDeclaringType() instanceof TypeObjectInputStream and
  m.getName().matches("read%")
  or
  m instanceof GetterMethod and
  m.getDeclaringType().getADescendant() instanceof SpringUntrustedDataType and
  not m.getDeclaringType() instanceof TypeObject
  or
  m.(TaintPreservingCallable).returnsTaintFrom(-1)
  or
  exists(JaxRsResourceMethod resourceMethod |
    m.(GetterMethod).getDeclaringType() = resourceMethod.getAParameter().getType()
  )
}

private class StringReplaceMethod extends TaintPreservingCallable {
  StringReplaceMethod() {
    this.getDeclaringType() instanceof TypeString and
    (
      this.hasName("replace") or
      this.hasName("replaceAll") or
      this.hasName("replaceFirst")
    )
  }

  override predicate returnsTaintFrom(int arg) { arg = 1 }
}

private predicate unsafeEscape(MethodAccess ma) {
  // Removing `<script>` tags using a string-replace method is
  // unsafe if such a tag is embedded inside another one (e.g. `<scr<script>ipt>`).
  exists(StringReplaceMethod m | ma.getMethod() = m |
    ma.getArgument(0).(StringLiteral).getValue() = "(<script>)" and
    ma.getArgument(1).(StringLiteral).getValue() = ""
  )
}

/** Access to a method that passes taint from an argument. */
private predicate argToMethodStep(Expr tracked, MethodAccess sink) {
  exists(Method m, int i |
    m = sink.getMethod() and
    taintPreservingArgumentToMethod(m, argToParam(sink, i)) and
    tracked = sink.getArgument(i)
  )
  or
  exists(Method springResponseEntityOfOk |
    sink.getMethod() = springResponseEntityOfOk and
    springResponseEntityOfOk.getDeclaringType() instanceof SpringResponseEntity and
    springResponseEntityOfOk.getName().regexpMatch("ok|of") and
    tracked = sink.getArgument(0) and
    tracked.getType() instanceof TypeString
  )
  or
  exists(Method springResponseEntityBody |
    sink.getMethod() = springResponseEntityBody and
    springResponseEntityBody.getDeclaringType() instanceof SpringResponseEntityBodyBuilder and
    springResponseEntityBody.getName().regexpMatch("body") and
    tracked = sink.getArgument(0) and
    tracked.getType() instanceof TypeString
  )
}

/**
 * Holds if `method` is a library method that returns tainted data if its
 * `arg`th argument is tainted.
 */
private predicate taintPreservingArgumentToMethod(Method method, int arg) {
  method.getDeclaringType().hasQualifiedName("org.apache.commons.codec.binary", "Base64") and
  (
    method.getName() = "decodeBase64" and arg = 0
    or
    method.getName().matches("encodeBase64%") and arg = 0
  )
  or
  method.(TaintPreservingCallable).returnsTaintFrom(arg)
}

/**
 * Holds if `tracked` and `sink` are arguments to a method that transfers taint
 * between arguments.
 */
private predicate argToArgStep(Expr tracked, Expr sink) {
  exists(MethodAccess ma, Method method, int input, int output |
    method.(TaintPreservingCallable).transfersTaint(argToParam(ma, input), argToParam(ma, output)) and
    ma.getMethod() = method and
    ma.getArgument(input) = tracked and
    ma.getArgument(output) = sink
  )
}

/**
 * Holds if `tracked` is the argument of a method that transfers taint
 * from the argument to the qualifier and `sink` is the qualifier.
 */
private predicate argToQualifierStep(Expr tracked, Expr sink) {
  exists(Method m, int i, MethodAccess ma |
    taintPreservingArgumentToQualifier(m, argToParam(ma, i)) and
    ma.getMethod() = m and
    tracked = ma.getArgument(i) and
    sink = ma.getQualifier()
  )
}

/**
 * Holds if `method` is a method that transfers taint from argument to qualifier and
 * `arg` is the index of the argument.
 */
private predicate taintPreservingArgumentToQualifier(Method method, int arg) {
  method.(TaintPreservingCallable).transfersTaint(arg, -1)
}

/** A comparison or equality test with a constant. */
private predicate comparisonStep(Expr tracked, Expr sink) {
  exists(Expr other |
    exists(BinaryExpr e | e instanceof ComparisonExpr or e instanceof EqualityTest |
      e = sink and
      e.hasOperands(tracked, other)
    )
    or
    exists(MethodAccess m | m.getMethod() instanceof EqualsMethod |
      m = sink and
      (
        m.getQualifier() = tracked and m.getArgument(0) = other
        or
        m.getQualifier() = other and m.getArgument(0) = tracked
      )
    )
  |
    other.isCompileTimeConstant() or other instanceof NullLiteral
  )
}

/** Flow through data serialization. */
private predicate serializationStep(Expr tracked, Expr sink) {
  exists(ObjectOutputStreamVar v, VariableAssign def |
    def = v.getADef() and
    exists(MethodAccess ma, RValue use |
      ma.getArgument(0) = tracked and
      ma = v.getAWriteObjectMethodAccess() and
      use = ma.getQualifier() and
      defUsePair(def, use)
    ) and
    exists(RValue outputstream, ClassInstanceExpr cie |
      cie = def.getSource() and
      outputstream = cie.getArgument(0) and
      adjacentUseUse(outputstream, sink)
    )
  )
}

/**
 * A local variable that is assigned an `ObjectOutputStream`.
 * Writing tainted data to such a stream causes the underlying
 * `OutputStream` to be tainted.
 */
class ObjectOutputStreamVar extends LocalVariableDecl {
  ObjectOutputStreamVar() {
    exists(ClassInstanceExpr cie | cie = this.getAnAssignedValue() |
      cie.getType() instanceof TypeObjectOutputStream
    )
  }

  VariableAssign getADef() {
    result.getSource().(ClassInstanceExpr).getType() instanceof TypeObjectOutputStream and
    result.getDestVar() = this
  }

  MethodAccess getAWriteObjectMethodAccess() {
    result.getQualifier() = this.getAnAccess() and
    result.getMethod().hasName("writeObject")
  }
}

/** Flow through string formatting. */
private predicate formatStep(Expr tracked, Expr sink) {
  exists(FormatterVar v, VariableAssign def |
    def = v.getADef() and
    exists(MethodAccess ma, RValue use |
      ma.getAnArgument() = tracked and
      ma = v.getAFormatMethodAccess() and
      use = ma.getQualifier() and
      defUsePair(def, use)
    ) and
    exists(RValue output, ClassInstanceExpr cie |
      cie = def.getSource() and
      output = cie.getArgument(0) and
      adjacentUseUse(output, sink) and
      exists(RefType t | output.getType().(RefType).getASourceSupertype*() = t |
        t.hasQualifiedName("java.io", "OutputStream") or
        t.hasQualifiedName("java.lang", "Appendable")
      )
    )
  )
}

/**
 * A local variable that is assigned a `Formatter`.
 * Writing tainted data to such a formatter causes the underlying
 * `OutputStream` or `Appendable` to be tainted.
 */
private class FormatterVar extends LocalVariableDecl {
  FormatterVar() {
    exists(ClassInstanceExpr cie | cie = this.getAnAssignedValue() |
      cie.getType() instanceof TypeFormatter
    )
  }

  VariableAssign getADef() {
    result.getSource().(ClassInstanceExpr).getType() instanceof TypeFormatter and
    result.getDestVar() = this
  }

  MethodAccess getAFormatMethodAccess() {
    result.getQualifier() = this.getAnAccess() and
    result.getMethod().hasName("format")
  }
}

/** The class `java.util.Formatter`. */
private class TypeFormatter extends Class {
  TypeFormatter() { this.hasQualifiedName("java.util", "Formatter") }
}

private class FormatterCallable extends TaintPreservingCallable {
  FormatterCallable() {
    this.getDeclaringType() instanceof TypeFormatter and
    (
      this.hasName(["format", "out", "toString"])
      or
      this.(Constructor)
          .getParameterType(0)
          .(RefType)
          .getASourceSupertype*()
          .hasQualifiedName("java.lang", "Appendable")
    )
  }

  override predicate returnsTaintFrom(int arg) {
    if this instanceof Constructor then arg = 0 else arg = [-1 .. this.getNumberOfParameters()]
  }

  override predicate transfersTaint(int src, int sink) {
    this.hasName("format") and
    sink = -1 and
    src = [0 .. this.getNumberOfParameters()]
  }
}

private import StringBuilderVarModule

module StringBuilderVarModule {
  /**
   * A local variable that is initialized to a `StringBuilder`
   * or `StringBuffer`. Such variables are often used to
   * build up a query using string concatenation.
   */
  class StringBuilderVar extends LocalVariableDecl {
    StringBuilderVar() { this.getType() instanceof StringBuildingType }

    /**
     * Gets a call that adds something to this string builder, from the argument at the given index.
     */
    MethodAccess getAnInput(int arg) {
      result.getQualifier() = this.getAChainedReference() and
      (
        result.getMethod().getName() = "append" and arg = 0
        or
        result.getMethod().getName() = "insert" and arg = 1
        or
        result.getMethod().getName() = "replace" and arg = 2
      )
    }

    /**
     * Gets a call that appends something to this string builder.
     */
    MethodAccess getAnAppend() {
      result.getQualifier() = this.getAChainedReference() and
      result.getMethod().getName() = "append"
    }

    MethodAccess getNextAppend(MethodAccess append) {
      result = this.getAnAppend() and
      append = this.getAnAppend() and
      (
        result.getQualifier() = append
        or
        not exists(MethodAccess chainAccess | chainAccess.getQualifier() = append) and
        exists(RValue sbva1, RValue sbva2 |
          adjacentUseUse(sbva1, sbva2) and
          append.getQualifier() = this.getAChainedReference(sbva1) and
          result.getQualifier() = sbva2
        )
      )
    }

    /**
     * Gets a call that converts this string builder to a string.
     */
    MethodAccess getToStringCall() {
      result.getQualifier() = this.getAChainedReference() and
      result.getMethod().getName() = "toString"
    }

    private Expr getAChainedReference(VarAccess sbva) {
      // All the methods on `StringBuilder` that return the same type return
      // the same object.
      result = callReturningSameType+(sbva) and sbva = this.getAnAccess()
      or
      result = sbva and sbva = this.getAnAccess()
    }

    /**
     * Gets an expression that refers to this `StringBuilder`, possibly after some chained calls.
     */
    Expr getAChainedReference() { result = this.getAChainedReference(_) }
  }
}

private MethodAccess callReturningSameType(Expr ref) {
  ref = result.getQualifier() and
  result.getMethod().getReturnType() = ref.getType()
}

private SrcRefType entrypointType() {
  exists(RemoteFlowSource s, RefType t |
    s instanceof DataFlow::ExplicitParameterNode and
    t = pragma[only_bind_out](s).getType() and
    not t instanceof TypeObject and
    result = t.getADescendant().getSourceDeclaration()
  )
  or
  result = entrypointType().getAField().getType().(RefType).getSourceDeclaration()
}

private predicate entrypointFieldStep(DataFlow::Node src, DataFlow::Node sink) {
  src = DataFlow::getFieldQualifier(sink.asExpr().(FieldRead)) and
  src.getType().(RefType).getSourceDeclaration() = entrypointType()
}
