/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.Collections
private import SSA
private import DefUse
private import semmle.code.java.security.SecurityTests
private import semmle.code.java.security.Validation
private import semmle.code.java.frameworks.android.Intent
private import semmle.code.java.frameworks.Guice
private import semmle.code.java.frameworks.Protobuf
private import semmle.code.java.Maps
private import semmle.code.java.dataflow.internal.ContainerFlow

module TaintTracking {
  /**
   * A taint tracking configuration.
   *
   * A taint tracking configuration is a special dataflow configuration
   * (`DataFlow::Configuration`) that allows for flow through nodes that do not
   * necessarily preserve values, but are still relevant from a taint tracking
   * perspective. (For example, string concatenation, where one of the operands
   * is tainted.)
   *
   * Each use of the taint tracking library must define its own unique extension
   * of this abstract class. A configuration defines a set of relevant sources
   * (`isSource`) and sinks (`isSink`), and may additionally treat intermediate
   * nodes as "sanitizers" (`isSanitizer`) as well as add custom taint flow steps
   * (`isAdditionalTaintStep()`).
   */
  abstract class Configuration extends DataFlow::Configuration {
    bindingset[this]
    Configuration() { any() }

    /**
     * Holds if `source` is a relevant taint source.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSource(DataFlow::Node source);

    /**
     * Holds if `sink` is a relevant taint sink.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSink(DataFlow::Node sink);

    /** Holds if the node `node` is a taint sanitizer. */
    predicate isSanitizer(DataFlow::Node node) { none() }

    final override predicate isBarrier(DataFlow::Node node) {
      isSanitizer(node) or
      // Ignore paths through test code.
      node.getEnclosingCallable().getDeclaringType() instanceof NonSecurityTestClass or
      node.asExpr() instanceof ValidatedVariableAccess
    }

    /** Holds if the edge from `node1` to `node2` is a taint sanitizer. */
    predicate isSanitizerEdge(DataFlow::Node node1, DataFlow::Node node2) { none() }

    final override predicate isBarrierEdge(DataFlow::Node node1, DataFlow::Node node2) {
      isSanitizerEdge(node1, node2)
    }

    /**
     * Holds if the additional taint propagation step from `node1` to `node2`
     * must be taken into account in the analysis.
     */
    predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

    final override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      isAdditionalTaintStep(node1, node2) or
      localAdditionalTaintStep(node1, node2)
    }

    /**
     * Holds if taint may flow from `source` to `sink` for this configuration.
     */
    // overridden to provide taint-tracking specific qldoc
    override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
      super.hasFlow(source, sink)
    }
  }

  /**
   * A taint tracking configuration.
   *
   * A taint tracking configuration is a special dataflow configuration
   * (`DataFlow::Configuration`) that allows for flow through nodes that do not
   * necessarily preserve values, but are still relevant from a taint tracking
   * perspective. (For example, string concatenation, where one of the operands
   * is tainted.)
   *
   * Each use of the taint tracking library must define its own unique extension
   * of this abstract class. A configuration defines a set of relevant sources
   * (`isSource`) and sinks (`isSink`), and may additionally treat intermediate
   * nodes as "sanitizers" (`isSanitizer`) as well as add custom taint flow steps
   * (`isAdditionalTaintStep()`).
   */
  abstract class Configuration2 extends DataFlow2::Configuration {
    bindingset[this]
    Configuration2() { any() }

    /**
     * Holds if `source` is a relevant taint source.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSource(DataFlow::Node source);

    /**
     * Holds if `sink` is a relevant taint sink.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSink(DataFlow::Node sink);

    /** Holds if the node `node` is a taint sanitizer. */
    predicate isSanitizer(DataFlow::Node node) { none() }

    final override predicate isBarrier(DataFlow::Node node) {
      isSanitizer(node) or
      // Ignore paths through test code.
      node.getEnclosingCallable().getDeclaringType() instanceof NonSecurityTestClass or
      node.asExpr() instanceof ValidatedVariableAccess
    }

    /** Holds if the edge from `node1` to `node2` is a taint sanitizer. */
    predicate isSanitizerEdge(DataFlow::Node node1, DataFlow::Node node2) { none() }

    final override predicate isBarrierEdge(DataFlow::Node node1, DataFlow::Node node2) {
      isSanitizerEdge(node1, node2)
    }

    /**
     * Holds if the additional taint propagation step from `node1` to `node2`
     * must be taken into account in the analysis.
     */
    predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

    final override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      isAdditionalTaintStep(node1, node2) or
      localAdditionalTaintStep(node1, node2)
    }

    /**
     * Holds if taint may flow from `source` to `sink` for this configuration.
     */
    // overridden to provide taint-tracking specific qldoc
    override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
      super.hasFlow(source, sink)
    }
  }

  /**
   * Holds if taint can flow from `src` to `sink` in zero or more
   * local (intra-procedural) steps.
   */
  predicate localTaint(DataFlow::Node src, DataFlow::Node sink) { localTaintStep*(src, sink) }

  /**
   * Holds if taint can flow in one local step from `src` to `sink`.
   */
  predicate localTaintStep(DataFlow::Node src, DataFlow::Node sink) {
    DataFlow::localFlowStep(src, sink) or
    localAdditionalTaintStep(src, sink)
  }

  /**
   * Holds if taint can flow in one local step from `src` to `sink` excluding
   * local data flow steps. That is, `src` and `sink` are likely to represent
   * different objects.
   */
  predicate localAdditionalTaintStep(DataFlow::Node src, DataFlow::Node sink) {
    localAdditionalTaintExprStep(src.asExpr(), sink.asExpr())
    or
    exists(Argument arg |
      src.asExpr() = arg and
      arg.isVararg() and
      sink.(DataFlow::ImplicitVarargsArray).getCall() = arg.getCall()
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
    sink.(ArrayCreationExpr).getInit() = src
    or
    sink.(ArrayInit).getAnInit() = src
    or
    sink.(ArrayAccess).getArray() = src
    or
    sink.(LogicExpr).getAnOperand() = src
    or
    exists(Assignment assign | assign.getSource() = src |
      sink = assign.getDest().(ArrayAccess).getArray()
    )
    or
    exists(EnhancedForStmt for, SsaExplicitUpdate v |
      for.getExpr() = src and
      v.getDefiningExpr() = for.getVariable() and
      v.getAFirstUse() = sink
    )
    or
    containerStep(src, sink)
    or
    constructorStep(src, sink)
    or
    qualifierToMethodStep(src, sink)
    or
    qualifierToArgumentStep(src, sink)
    or
    argToMethodStep(src, sink)
    or
    argToArgStep(src, sink)
    or
    argToQualifierStep(src, sink)
    or
    comparisonStep(src, sink)
    or
    stringBuilderStep(src, sink)
    or
    serializationStep(src, sink)
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
      exists(string s | sink.getConstructedType().getQualifiedName() = s |
        // String constructor does nothing to data
        s = "java.lang.String" and argi = 0
        or
        // some readers preserve the content of streams
        s = "java.io.InputStreamReader" and argi = 0
        or
        s = "java.io.BufferedReader" and argi = 0
        or
        s = "java.io.CharArrayReader" and argi = 0
        or
        s = "java.io.StringReader" and argi = 0
        or
        // data preserved through streams
        s = "java.io.ObjectInputStream" and argi = 0
        or
        s = "java.io.ByteArrayInputStream" and argi = 0
        or
        s = "java.io.DataInputStream" and argi = 0
        or
        s = "java.io.BufferedInputStream" and argi = 0
        or
        s = "com.esotericsoftware.kryo.io.Input" and argi = 0
        or
        s = "java.beans.XMLDecoder" and argi = 0
        or
        // a tokenizer preserves the content of a string
        s = "java.util.StringTokenizer" and argi = 0
        or
        // unzipping the stream preserves content
        s = "java.util.zip.ZipInputStream" and argi = 0
        or
        s = "java.util.zip.GZIPInputStream" and argi = 0
        or
        // string builders and buffers
        s = "java.lang.StringBuilder" and argi = 0
        or
        s = "java.lang.StringBuffer" and argi = 0
        or
        // a cookie with tainted ingredients is tainted
        s = "javax.servlet.http.Cookie" and argi = 0
        or
        s = "javax.servlet.http.Cookie" and argi = 1
        or
        // various xml stream source constructors.
        s = "org.xml.sax.InputSource" and argi = 0
        or
        s = "javax.xml.transform.sax.SAXSource" and argi = 0 and sink.getNumArgument() = 1
        or
        s = "javax.xml.transform.sax.SAXSource" and argi = 1 and sink.getNumArgument() = 2
        or
        s = "javax.xml.transform.stream.StreamSource" and argi = 0
        or
        //a URI constructed from a tainted string is tainted.
        s = "java.net.URI" and argi = 0 and sink.getNumArgument() = 1
      )
      or
      exists(RefType t | t.getQualifiedName() = "java.lang.Number" |
        hasSubtype*(t, sink.getConstructedType())
      ) and
      argi = 0
      or
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
    )
  }

  /** Access to a method that passes taint from qualifier to argument. */
  private predicate qualifierToArgumentStep(Expr tracked, RValue sink) {
    exists(MethodAccess ma, int arg |
      taintPreservingQualifierToArgument(ma.getMethod(), arg) and
      tracked = ma.getQualifier() and
      sink = ma.getArgument(arg)
    )
  }

  /** Methods that passes tainted data from qualifier to argument. */
  private predicate taintPreservingQualifierToArgument(Method m, int arg) {
    m.getDeclaringType().hasQualifiedName("java.io", "ByteArrayOutputStream") and
    m.hasName("writeTo") and
    arg = 0
    or
    m.getDeclaringType().hasQualifiedName("java.io", "InputStream") and
    m.hasName("read") and
    arg = 0
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
    m.getDeclaringType() instanceof TypeString and
    (
      m.getName() = "concat" or
      m.getName() = "endsWith" or
      m.getName() = "getBytes" or
      m.getName() = "split" or
      m.getName() = "substring" or
      m.getName() = "toCharArray" or
      m.getName() = "toLowerCase" or
      m.getName() = "toString" or
      m.getName() = "toUpperCase" or
      m.getName() = "trim"
    )
    or
    exists(Class c | c.getQualifiedName() = "java.lang.Number" |
      hasSubtype*(c, m.getDeclaringType())
    ) and
    (
      m.getName().matches("to%String") or
      m.getName() = "toByteArray" or
      m.getName().matches("%Value")
    )
    or
    m.getDeclaringType().getQualifiedName().matches("%Reader") and
    m.getName().matches("read%")
    or
    m.getDeclaringType().getQualifiedName().matches("%StringWriter") and
    m.getName() = "toString"
    or
    m.getDeclaringType().hasQualifiedName("java.util", "StringTokenizer") and
    m.getName().matches("next%")
    or
    m.getDeclaringType().hasQualifiedName("java.io", "ByteArrayOutputStream") and
    (m.getName() = "toByteArray" or m.getName() = "toString")
    or
    m.getDeclaringType().hasQualifiedName("java.io", "ObjectInputStream") and
    m.getName().matches("read%")
    or
    (
      m.getDeclaringType().hasQualifiedName("java.lang", "StringBuilder") or
      m.getDeclaringType().hasQualifiedName("java.lang", "StringBuffer")
    ) and
    (m.getName() = "toString" or m.getName() = "append")
    or
    m.getDeclaringType().hasQualifiedName("javax.xml.transform.sax", "SAXSource") and
    m.hasName("getInputSource")
    or
    m.getDeclaringType().hasQualifiedName("javax.xml.transform.stream", "StreamSource") and
    m.hasName("getInputStream")
    or
    m instanceof IntentGetExtraMethod
    or
    m.getDeclaringType().hasQualifiedName("java.nio", "ByteBuffer") and
    m.hasName("get")
    or
    m = any(GuiceProvider gp).getAnOverridingGetMethod()
    or
    m = any(ProtobufMessageLite p).getAGetterMethod()
  }

  private class StringReplaceMethod extends Method {
    StringReplaceMethod() {
      getDeclaringType() instanceof TypeString and
      (
        hasName("replace") or
        hasName("replaceAll") or
        hasName("replaceFirst")
      )
    }
  }

  private predicate unsafeEscape(MethodAccess ma) {
    // Removing `<script>` tags using a string-replace method is
    // unsafe if such a tag is embedded inside another one (e.g. `<scr<script>ipt>`).
    exists(StringReplaceMethod m | ma.getMethod() = m |
      ma.getArgument(0).(StringLiteral).getRepresentedString() = "(<script>)" and
      ma.getArgument(1).(StringLiteral).getRepresentedString() = ""
    )
  }

  /** Access to a method that passes taint from an argument. */
  private predicate argToMethodStep(Expr tracked, MethodAccess sink) {
    exists(Method m, int i |
      m = sink.(MethodAccess).getMethod() and
      taintPreservingArgumentToMethod(m, i) and
      tracked = sink.(MethodAccess).getArgument(i)
    )
  }

  /**
   * Holds if `method` is a library method that return tainted data if its
   * `arg`th argument is tainted.
   */
  private predicate taintPreservingArgumentToMethod(Method method, int arg) {
    method instanceof StringReplaceMethod and arg = 1
    or
    exists(Class c | c.getQualifiedName() = "java.lang.Number" |
      hasSubtype*(c, method.getDeclaringType())
    ) and
    (
      method.getName().matches("parse%") and arg = 0
      or
      method.getName().matches("valueOf%") and arg = 0
      or
      method.getName().matches("to%String") and arg = 0
    )
    or
    method.getDeclaringType() instanceof TypeString and
    method.getName() = "concat" and
    arg = 0
    or
    (
      method.getDeclaringType().hasQualifiedName("java.lang", "StringBuilder") or
      method.getDeclaringType().hasQualifiedName("java.lang", "StringBuffer")
    ) and
    (
      method.getName() = "append" and arg = 0
      or
      method.getName() = "insert" and arg = 1
      or
      method.getName() = "replace" and arg = 2
    )
    or
    (
      method.getDeclaringType().hasQualifiedName("java.util", "Base64$Encoder") or
      method.getDeclaringType().hasQualifiedName("java.util", "Base64$Decoder")
    ) and
    (
      method.getName() = "encode" and arg = 0 and method.getNumberOfParameters() = 1
      or
      method.getName() = "decode" and arg = 0 and method.getNumberOfParameters() = 1
      or
      method.getName() = "encodeToString" and arg = 0
      or
      method.getName() = "wrap" and arg = 0
    )
    or
    method.getDeclaringType().hasQualifiedName("org.apache.commons.io", "IOUtils") and
    (
      method.getName() = "buffer" and arg = 0
      or
      method.getName() = "readLines" and arg = 0
      or
      method.getName() = "readFully" and arg = 0 and method.getParameterType(1).hasName("int")
      or
      method.getName() = "toBufferedInputStream" and arg = 0
      or
      method.getName() = "toBufferedReader" and arg = 0
      or
      method.getName() = "toByteArray" and arg = 0
      or
      method.getName() = "toCharArray" and arg = 0
      or
      method.getName() = "toInputStream" and arg = 0
      or
      method.getName() = "toString" and arg = 0
    )
    or
    // A URI created from a tainted string is still tainted.
    method.getDeclaringType().hasQualifiedName("java.net", "URI") and
    method.hasName("create") and
    arg = 0
    or
    method.getDeclaringType().hasQualifiedName("javax.xml.transform.sax", "SAXSource") and
    method.hasName("sourceToInputSource") and
    arg = 0
    or
    exists(ProtobufParser p | method = p.getAParseFromMethod()) and
    arg = 0
    or
    exists(ProtobufMessageLite m | method = m.getAParseFromMethod()) and
    arg = 0
  }

  /**
   * Holds if `tracked` and `sink` are arguments to a method that transfers taint
   * between arguments.
   */
  private predicate argToArgStep(Expr tracked, RValue sink) {
    exists(MethodAccess ma, Method method, int input, int output |
      taintPreservingArgToArg(method, input, output) and
      ma.getMethod() = method and
      ma.getArgument(input) = tracked and
      ma.getArgument(output) = sink
    )
  }

  /**
   * Holds if `method` is a library method that writes tainted data to the
   * `output`th argument if the `input`th argument is tainted.
   */
  private predicate taintPreservingArgToArg(Method method, int input, int output) {
    method.getDeclaringType().hasQualifiedName("org.apache.commons.io", "IOUtils") and
    (
      method.hasName("copy") and input = 0 and output = 1
      or
      method.hasName("copyLarge") and input = 0 and output = 1
      or
      method.hasName("read") and input = 0 and output = 1
      or
      method.hasName("readFully") and
      input = 0 and
      output = 1 and
      not method.getParameterType(1).hasName("int")
      or
      method.hasName("write") and input = 0 and output = 1
      or
      method.hasName("writeChunked") and input = 0 and output = 1
      or
      method.hasName("writeLines") and input = 0 and output = 2
      or
      method.hasName("writeLines") and input = 1 and output = 2
    )
    or
    method.getDeclaringType().hasQualifiedName("java.lang", "System") and
    method.hasName("arraycopy") and
    input = 0 and
    output = 2
  }

  /**
   * Holds if `tracked` is the argument of a method that transfers taint
   * from the argument to the qualifier and `sink` is the qualifier.
   */
  private predicate argToQualifierStep(Expr tracked, Expr sink) {
    exists(Method m, int i, MethodAccess ma |
      taintPreservingArgumentToQualifier(m, i) and
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
    method.getDeclaringType().hasQualifiedName("java.io", "ByteArrayOutputStream") and
    method.hasName("write") and
    arg = 0
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

  /** Flow through a `StringBuilder`. */
  private predicate stringBuilderStep(Expr tracked, Expr sink) {
    exists(StringBuilderVar sbvar, MethodAccess input, int arg |
      input = sbvar.getAnInput(arg) and
      tracked = input.getArgument(arg) and
      sink = sbvar.getToStringCall()
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
      result.getQualifier() = getAnAccess() and
      result.getMethod().hasName("writeObject")
    }
  }
}

/**
 * A local variable that is initialized to a `StringBuilder`
 * or `StringBuffer`. Such variables are often used to
 * build up a query using string concatenation.
 */
class StringBuilderVar extends LocalVariableDecl {
  StringBuilderVar() {
    this.getType() instanceof TypeStringBuilder or
    this.getType() instanceof TypeStringBuffer
  }

  /**
   * Gets a call that adds something to this string builder, from the argument at the given index.
   */
  MethodAccess getAnInput(int arg) {
    result.getQualifier() = getAChainedReference() and
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
    result.getQualifier() = getAChainedReference() and
    result.getMethod().getName() = "append"
  }

  MethodAccess getNextAppend(MethodAccess append) {
    result = getAnAppend() and
    append = getAnAppend() and
    (
      result.getQualifier() = append
      or
      not exists(MethodAccess chainAccess | chainAccess.getQualifier() = append) and
      exists(RValue sbva1, RValue sbva2 |
        adjacentUseUse(sbva1, sbva2) and
        append.getQualifier() = getAChainedReference(sbva1) and
        result.getQualifier() = sbva2
      )
    )
  }

  /**
   * Gets a call that converts this string builder to a string.
   */
  MethodAccess getToStringCall() {
    result.getQualifier() = getAChainedReference() and
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
  Expr getAChainedReference() { result = getAChainedReference(_) }
}

private MethodAccess callReturningSameType(Expr ref) {
  ref = result.getQualifier() and
  result.getMethod().getReturnType() = ref.getType()
}
