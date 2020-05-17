private import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.Collections
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dataflow.DefUse
private import semmle.code.java.security.SecurityTests
private import semmle.code.java.security.Validation
private import semmle.code.java.frameworks.android.Intent
private import semmle.code.java.frameworks.Guice
private import semmle.code.java.frameworks.Protobuf
private import semmle.code.java.frameworks.spring.SpringController
private import semmle.code.java.frameworks.spring.SpringHttp
private import semmle.code.java.Maps
private import semmle.code.java.dataflow.internal.ContainerFlow
private import semmle.code.java.frameworks.jackson.JacksonSerializability

/**
 * Holds if taint can flow from `src` to `sink` in zero or more
 * local (intra-procedural) steps.
 */
predicate localTaint(DataFlow::Node src, DataFlow::Node sink) { localTaintStep*(src, sink) }

/**
 * Holds if taint can flow from `src` to `sink` in zero or more
 * local (intra-procedural) steps.
 */
predicate localExprTaint(Expr src, Expr sink) {
  localTaint(DataFlow::exprNode(src), DataFlow::exprNode(sink))
}

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
  localAdditionalTaintUpdateStep(src.asExpr(),
    sink.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr())
  or
  exists(Argument arg |
    src.asExpr() = arg and
    arg.isVararg() and
    sink.(DataFlow::ImplicitVarargsArray).getCall() = arg.getCall()
  )
}

private newtype TUnit = TMkUnit()

class Unit extends TUnit {
  string toString() { result = "unit" }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to all
 * taint configurations.
 */
class AdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for all configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/**
 * Holds if the additional step from `src` to `sink` should be included in all
 * global taint flow configurations.
 */
predicate defaultAdditionalTaintStep(DataFlow::Node src, DataFlow::Node sink) {
  localAdditionalTaintStep(src, sink) or
  any(AdditionalTaintStep a).step(src, sink)
}

/**
 * Holds if `node` should be a barrier in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintBarrier(DataFlow::Node node) {
  // Ignore paths through test code.
  node.getEnclosingCallable().getDeclaringType() instanceof NonSecurityTestClass or
  node.asExpr() instanceof ValidatedVariableAccess
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
  exists(EnhancedForStmt for, SsaExplicitUpdate v |
    for.getExpr() = src and
    v.getDefiningExpr() = for.getVariable() and
    v.getAFirstUse() = sink
  )
  or
  containerReturnValueStep(src, sink)
  or
  constructorStep(src, sink)
  or
  qualifierToMethodStep(src, sink)
  or
  argToMethodStep(src, sink)
  or
  comparisonStep(src, sink)
  or
  stringBuilderStep(src, sink)
  or
  serializationStep(src, sink)
}

/**
 * Holds if taint can flow in one local step from `src` to `sink` excluding
 * local data flow steps. That is, `src` and `sink` are likely to represent
 * different objects.
 * This is restricted to cases where the step updates the value of `sink`.
 */
private predicate localAdditionalTaintUpdateStep(Expr src, Expr sink) {
  exists(Assignment assign | assign.getSource() = src |
    sink = assign.getDest().(ArrayAccess).getArray()
  )
  or
  containerUpdateStep(src, sink)
  or
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
    or
    // A SpringHttpEntity is a wrapper around a body and some headers
    // Track flow through iff body is a String
    exists(SpringHttpEntity she |
      sink.getConstructor() = she.getAConstructor() and
      argi = 0 and
      tracked.getType() instanceof TypeString
    )
    or
    // A SpringRequestEntity is a wrapper around a body and some headers
    // Track flow through iff body is a String
    exists(SpringResponseEntity sre |
      sink.getConstructor() = sre.getAConstructor() and
      argi = 0 and
      tracked.getType() instanceof TypeString
    )
  )
}

/** Access to a method that passes taint from qualifier to argument. */
private predicate qualifierToArgumentStep(Expr tracked, Expr sink) {
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
  exists(Method read |
    m.overrides*(read) and
    read.getDeclaringType().hasQualifiedName("java.io", "InputStream") and
    read.hasName("read") and
    arg = 0
  )
  or
  m.getDeclaringType().getASupertype*().hasQualifiedName("java.io", "Reader") and
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
    m.getName() = "formatted" or
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
  exists(Class c | c.getQualifiedName() = "java.lang.Number" | hasSubtype*(c, m.getDeclaringType())) and
  (
    m.getName().matches("to%String") or
    m.getName() = "toByteArray" or
    m.getName().matches("%Value")
  )
  or
  m.getDeclaringType().getASupertype*().hasQualifiedName("java.io", "Reader") and
  (
    m.getName() = "read" and m.getNumberOfParameters() = 0
    or
    m.getName() = "readLine"
  )
  or
  m.getDeclaringType().getQualifiedName().matches("%StringWriter") and
  (
    m.getName() = "getBuffer"
    or
    m.getName() = "toString"
  )
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
    m.getDeclaringType().hasQualifiedName("java.lang", "StringBuffer") or
    m.getDeclaringType().hasQualifiedName("java.io", "StringWriter")
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
  or
  m instanceof MapMethod and
  (
    m.getName().regexpMatch("get|entrySet|keySet|values")
  )
  or
  m.getDeclaringType().getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "List") and
  (
    m.getName().regexpMatch("get|toArray|subList|spliterator|set|iterator|listIterator") or
    (m.getName().regexpMatch("remove") and not m.getReturnType() instanceof BooleanType)
  )
  or
  m instanceof StringReplaceMethod
  or
  exists(SpringUntrustedDataType dt |
    m.(GetterMethod) = dt.getAMethod()
  )
  or
  exists(SpringHttpEntity sre |
    m = sre.getAMethod() and
    m.getName().regexpMatch("getBody|getHeaders")
  )
  or
  exists(SpringHttpHeaders headers |
    m = headers.getAMethod() |
    m.getReturnType() instanceof TypeString
    or
    m.getReturnType().(RefType).getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "List") and
    m.getReturnType().(ParameterizedType).getTypeArgument(0) instanceof TypeString
  )
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
  or
  exists(MethodAccess ma |
    taintPreservingArgumentToMethod(ma.getMethod()) and
    tracked = ma.getAnArgument() and
    sink = ma
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
 * Holds if `method` is a library method that returns tainted data if any
 * of its arguments are tainted.
 */
private predicate taintPreservingArgumentToMethod(Method method) {
  method.getDeclaringType() instanceof TypeString and
  (method.hasName("format") or method.hasName("formatted") or method.hasName("join"))
}

/**
 * Holds if `method` is a library method that returns tainted data if its
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
    method.getDeclaringType().hasQualifiedName("java.util", "Base64$Decoder") or
    method
        .getDeclaringType()
        .getASupertype*()
        .hasQualifiedName("org.apache.commons.codec", "Encoder") or
    method
        .getDeclaringType()
        .getASupertype*()
        .hasQualifiedName("org.apache.commons.codec", "Decoder")
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
  method.getDeclaringType().hasQualifiedName("org.apache.commons.codec.binary", "Base64") and
  (
    method.getName() = "decodeBase64" and arg = 0
    or
    method.getName().matches("encodeBase64%") and arg = 0
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
  method.getDeclaringType().hasQualifiedName("java.net", "URLDecoder") and
  method.hasName("decode") and
  arg = 0
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
  or
  // Jackson serialization methods that return the serialized data
  method instanceof JacksonWriteValueMethod and
  method.getNumberOfParameters() = 1 and
  arg = 0
  or
  method.getDeclaringType().hasQualifiedName("java.io", "StringWriter") and
  method.hasName("append") and
  arg = 0
}

/**
 * Holds if `tracked` and `sink` are arguments to a method that transfers taint
 * between arguments.
 */
private predicate argToArgStep(Expr tracked, Expr sink) {
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
  or
  // Jackson serialization methods that write data to the first argument
  method instanceof JacksonWriteValueMethod and
  method.getNumberOfParameters() > 1 and
  input = method.getNumberOfParameters() - 1 and
  output = 0
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
  exists(Method write |
    method.overrides*(write) and
    write.hasName("write") and
    arg = 0 and
    (
      write.getDeclaringType().hasQualifiedName("java.io", "OutputStream")
      or
      write.getDeclaringType().hasQualifiedName("java.io", "StringWriter")
    )
  )
  or
  exists(Method append |
    method.overrides*(append) and
    append.hasName("append") and
    arg = 0 and
    append.getDeclaringType().hasQualifiedName("java.io", "StringWriter")
  )
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

private import StringBuilderVarModule

module StringBuilderVarModule {
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
}

private MethodAccess callReturningSameType(Expr ref) {
  ref = result.getQualifier() and
  result.getMethod().getReturnType() = ref.getType()
}
