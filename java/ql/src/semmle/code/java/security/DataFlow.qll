/**
 * DEPRECATED: Use semmle.code.java.dataflow.DataFlow, semmle.code.java.dataflow.TaintTracking, and semmle.code.java.dataflow.FlowSources instead.
 *
 * Data flow module in the security pack.
 *
 * This module tracks data through a program.
 */

import semmle.code.java.Expr
import semmle.code.java.frameworks.Jdbc
import semmle.code.java.frameworks.Networking
import semmle.code.java.frameworks.Properties
import semmle.code.java.frameworks.Rmi
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.ApacheHttp
import semmle.code.java.frameworks.android.XmlParsing
import semmle.code.java.frameworks.android.WebView
import semmle.code.java.frameworks.android.SQLite
import semmle.code.java.frameworks.JaxWS
import semmle.code.java.dataflow.DefUse
import semmle.code.java.dataflow.SSA
import semmle.code.java.security.SecurityTests
import semmle.code.java.security.Validation
import semmle.code.java.dispatch.VirtualDispatch

/**
 * DEPRECATED: Use semmle.code.java.dataflow.DataFlow, semmle.code.java.dataflow.TaintTracking, and semmle.code.java.dataflow.FlowSources instead.
 *
 * Class representing a source of data flow.
 */
deprecated class FlowSource extends Expr {
  /** Holds if this source flows to the `sink`. */
  predicate flowsTo(Expr sink) { flowsToAndLocal(sink.(FlowExpr)) }

  /**
   * The same as `flowsTo(sink,fromArg)`, plus `localFlow` and reads from instance fields.
   * This gives us a little bit of flow through instance fields, without
   * letting it escape back out of the class.
   */
  private predicate flowsToAndLocal(FlowExpr sink) {
    // Verify that the sink is not excluded for this `FlowSource`.
    not isExcluded(sink) and
    (
      flowsTo(sink, _)
      or
      exists(FlowExpr tracked |
        // The tracked expression should not be excluded for this `FlowSource`.
        not isExcluded(tracked) and
        flowsToAndLocal(tracked) and
        (
          localFlowStep(tracked, sink)
          or
          exists(Field field |
            tracked = field.getAnAssignedValue() and
            sink = field.getAnAccess()
          )
        )
      )
    )
  }

  /**
   * Sinks that this flow source flows to. The `fromArg` column is
   * `true` if the `sink` is in a method where one of the arguments
   * holds the same value as `sink`.
   */
  private predicate flowsTo(FlowExpr sink, boolean fromArg) {
    // Base case.
    sink = this and fromArg = false
    or
    exists(FlowExpr tracked |
      // The tracked expression should not be excluded for this `FlowSource`.
      not isExcluded(tracked)
    |
      // Flow within a single method.
      (
        flowsTo(tracked, fromArg) and
        localFlowStep(tracked, sink)
      )
      or
      // Flow through a field.
      (
        flowsTo(tracked, _) and
        staticFieldStep(tracked, sink) and
        fromArg = false
      )
      or
      // Flow through a method that returns one of its arguments.
      exists(MethodAccess call, int i |
        flowsTo(tracked, fromArg) and
        methodReturnsArg(responderForArg(call, i, tracked), i) and
        sink = call
      )
      or
      // Flow into a method.
      exists(Call c, Callable m, Parameter p, int i |
        flowsTo(tracked, _) and
        m = responderForArg(c, i, tracked) and
        m.getParameter(i) = p and
        parameterDefUsePair(p, sink) and
        fromArg = true
      )
      or
      // Flow out of a method.
      // This path is only enabled if the flow did not come from the argument;
      // such cases are handled by `methodReturnsArg`.
      (
        flowsTo(tracked, false) and
        methodStep(tracked, sink) and
        fromArg = false
      )
    )
  }

  /**
   * A version of `flowsTo` that searches backwards from the `sink` instead of
   * forwards from the source. This does not include flow paths across methods.
   */
  predicate flowsToReverse(Expr sink) {
    sink instanceof FlowExpr and
    // The tracked expression should not be excluded for this `FlowSource`.
    not isExcluded(sink.(FlowExpr)) and
    (
      sink = this
      or
      exists(FlowSource tracked | tracked.flowsToReverse(sink) | localFlowStep(this, tracked))
      or
      exists(FlowSource tracked | tracked.flowsToReverse(sink) | staticFieldStep(this, tracked))
      or
      exists(FlowSource tracked, MethodAccess call, int i |
        tracked.flowsToReverse(sink) and
        tracked = call and
        methodReturnsArg(call.getMethod(), i) and
        call.getArgument(i) = this
      )
    )
  }

  /**
   * Flow expressions that should be excluded by the flow analysis for this type of `FlowSource`.
   */
  predicate isExcluded(FlowExpr flowExpr) {
    // Nothing excluded by default
    none()
  }
}

/**
 * DEPRECATED: Use semmle.code.java.dataflow.DataFlow, semmle.code.java.dataflow.TaintTracking, and semmle.code.java.dataflow.FlowSources instead.
 *
 * Expressions that are considered valid for flow.
 * This should be private.
 */
deprecated class FlowExpr extends Expr {
  FlowExpr() {
    // Ignore paths through test code.
    not getEnclosingCallable().getDeclaringType() instanceof NonSecurityTestClass and
    not exists(ValidatedVariable var | this = var.getAnAccess())
  }
}

/** Gets the responders for a `call` with given argument. */
pragma[nomagic]
deprecated private Callable responderForArg(Call call, int i, FlowExpr tracked) {
  call.getArgument(i) = tracked and
  result = responder(call)
}

/** Gets the responders to consider when tracking flow through a `call`. */
deprecated private Callable responder(Call call) {
  result = exactCallable(call)
  or
  (
    not exists(exactCallable(call)) and
    result = call.getCallee()
  )
}

/** Holds if a method can return its argument. This is public for testing. */
deprecated predicate methodReturnsArg(Method method, int arg) {
  exists(ReturnStmt ret |
    ret.getEnclosingCallable() = method and
    ret.getResult() = parameterFlow(method, arg)
  )
}

/**
 * The local flow of a parameter, including flow through other methods
 * that return their argument.
 */
deprecated private Expr parameterFlow(Method method, int arg) {
  result = method.getParameter(arg).getAnAccess()
  or
  exists(Expr tracked | tracked = parameterFlow(method, arg) |
    localFlowStep(tracked, result)
    or
    exists(MethodAccess acc, int j |
      acc.getArgument(j) = tracked and
      methodReturnsArg(acc.getMethod(), j) and
      result = acc
    )
  )
}

/**
 * One step of flow within a single method.
 */
cached
deprecated private predicate localFlowStep(Expr tracked, Expr sink) {
  variableStep(tracked, sink)
  or
  // A concatenation of a tracked expression.
  sink.(AddExpr).getAnOperand() = tracked
  or
  // A parenthesized tracked expression.
  sink.(ParExpr).getExpr() = tracked
  or
  // A cast of a tracked expression.
  sink.(CastExpr).getExpr() = tracked
  or
  // A conditional expression with a tracked branch.
  sink.(ConditionalExpr).getTrueExpr() = tracked
  or
  sink.(ConditionalExpr).getFalseExpr() = tracked
  or
  // An array initialization or creation expression.
  sink.(ArrayCreationExpr).getInit() = tracked
  or
  sink.(ArrayInit).getAnInit() = tracked
  or
  // An access to an element of a tracked array.
  sink.(ArrayAccess).getArray() = tracked
  or
  arrayAccessStep(tracked, sink)
  or
  constructorStep(tracked, sink)
  or
  qualifierToMethodStep(tracked, sink)
  or
  argToMethodStep(tracked, sink)
  or
  // An unsafe attempt to escape tainted input.
  (unsafeEscape(sink) and sink.(MethodAccess).getQualifier() = tracked)
  or
  // A logic expression.
  sink.(LogicExpr).getAnOperand() = tracked
  or
  comparisonStep(tracked, sink)
  or
  stringBuilderStep(tracked, sink)
  or
  serializationStep(tracked, sink)
  or
  argToArgStep(tracked, sink)
}

/**
 * Holds if `tracked` and `sink` are arguments to a method that transfers taint
 * between arguments.
 */
deprecated private predicate argToArgStep(Expr tracked, VarAccess sink) {
  exists(MethodAccess ma, Method method, int input, int output, RValue out |
    dataPreservingArgToArg(method, input, output) and
    ma.getMethod() = method and
    ma.getArgument(input) = tracked and
    ma.getArgument(output) = out and
    useUsePair(out, sink)
  )
}

/**
 * Holds if `method` is a library method that writes tainted data to the
 * `output`th argument if the `input`th argument is tainted.
 */
deprecated private predicate dataPreservingArgToArg(Method method, int input, int output) {
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
}

/** A use of a variable that has been assigned a `tracked` expression. */
deprecated private predicate variableStep(Expr tracked, VarAccess sink) {
  exists(VariableAssign def |
    def.getSource() = tracked and
    defUsePair(def, sink)
  )
}

deprecated private predicate staticFieldStep(Expr tracked, FieldAccess sink) {
  exists(Field f |
    f.isStatic() and
    f.getAnAssignedValue() = tracked
  |
    f.getAnAccess() = sink
  )
}

/** An access to an array that has been assigned a `tracked` element. */
deprecated private predicate arrayAccessStep(Expr tracked, Expr sink) {
  exists(Assignment assign | assign.getSource() = tracked |
    sink = assign.getDest().(ArrayAccess).getArray().(VarAccess).getVariable().getAnAccess()
  )
}

/** An access to a method that returns a `tracked` expression. */
deprecated private predicate methodStep(Expr tracked, MethodAccess sink) {
  exists(Method m, ReturnStmt ret | ret.getResult() = tracked and ret.getEnclosingCallable() = m |
    m = responder(sink)
  )
}

/** Access to a method that passes taint from an argument. */
deprecated private predicate argToMethodStep(Expr tracked, MethodAccess sink) {
  exists(Method m, int i |
    m = sink.(MethodAccess).getMethod() and
    dataPreservingArgument(m, i) and
    tracked = sink.(MethodAccess).getArgument(i)
  )
}

/** A comparison or equality test with a constant. */
deprecated private predicate comparisonStep(Expr tracked, Expr sink) {
  exists(Expr other |
    (
      exists(BinaryExpr e | e instanceof ComparisonExpr or e instanceof EqualityTest |
        e = sink and
        e.getAnOperand() = tracked and
        e.getAnOperand() = other
      )
      or
      exists(MethodAccess m | m.getMethod() instanceof EqualsMethod |
        m = sink and
        (
          (m.getQualifier() = tracked and m.getArgument(0) = other)
          or
          (m.getQualifier() = other and m.getArgument(0) = tracked)
        )
      )
    ) and
    (other.isCompileTimeConstant() or other instanceof NullLiteral) and
    tracked != other
  )
}

/** Flow through a `StringBuilder`. */
deprecated private predicate stringBuilderStep(Expr tracked, Expr sink) {
  exists(StringBuilderVar sbvar |
    exists(MethodAccess input, int arg |
      input = sbvar.getAnInput(arg) and
      tracked = input.getArgument(arg)
    ) and
    sink = sbvar.getToStringCall()
  )
}

/** Flow through data serialization. */
deprecated private predicate serializationStep(Expr tracked, Expr sink) {
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
      useUsePair(outputstream, sink)
    )
  )
}

/**
 * A local variable that is assigned an `ObjectOutputStream`.
 * Writing tainted data to such a stream causes the underlying
 * `OutputStream` to be tainted.
 */
deprecated class ObjectOutputStreamVar extends LocalVariableDecl {
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

/**
 * DEPRECATED: Use semmle.code.java.dataflow.TaintTracking.TaintTracking::StringBuilderVar instead.
 *
 * A local variable that is initialized to a `StringBuilder`
 * or `StringBuffer`. Such variables are often used to
 * build up a query using string concatenation.
 */
deprecated class StringBuilderVar extends LocalVariableDecl {
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

deprecated private MethodAccess callReturningSameType(Expr ref) {
  ref = result.getQualifier() and
  result.getMethod().getReturnType() = ref.getType()
}

deprecated private class BulkData extends RefType {
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
deprecated private predicate inputStreamWrapper(Constructor c, int argi) {
  c.getParameterType(argi) instanceof BulkData and
  c.getDeclaringType().getASourceSupertype().hasQualifiedName("java.io", "InputStream")
}

/** An object construction that preserves the data flow status of any of its arguments. */
deprecated predicate constructorStep(Expr tracked, ConstructorCall sink) {
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
      hasSubtypeStar(t, sink.getConstructedType())
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

/** Access to a method that passes taint from the qualifier. */
deprecated predicate qualifierToMethodStep(Expr tracked, MethodAccess sink) {
  sink.getMethod() instanceof DataPreservingMethod and
  tracked = sink.getQualifier()
}

/**
 * Methods that return tainted data when called on tainted data.
 */
deprecated class DataPreservingMethod extends Method {
  DataPreservingMethod() {
    (
      this.getDeclaringType() instanceof TypeString and
      (
        this.getName() = "endsWith" or
        this.getName() = "getBytes" or
        this.getName() = "split" or
        this.getName() = "substring" or
        this.getName() = "toCharArray" or
        this.getName() = "toLowerCase" or
        this.getName() = "toString" or
        this.getName() = "toUpperCase" or
        this.getName() = "trim"
      )
    )
    or
    (
      exists(Class c | c.getQualifiedName() = "java.lang.Number" |
        hasSubtypeStar(c, this.getDeclaringType())
      ) and
      (
        this.getName().matches("to%String") or
        this.getName() = "toByteArray" or
        this.getName().matches("%Value")
      )
    )
    or
    (
      this.getDeclaringType().getQualifiedName().matches("%Reader") and
      this.getName().matches("read%")
    )
    or
    (
      this.getDeclaringType().getQualifiedName().matches("%StringWriter") and
      this.getName() = "toString"
    )
    or
    (
      this.getDeclaringType().hasQualifiedName("java.util", "StringTokenizer") and
      this.getName().matches("next%")
    )
    or
    (
      this.getDeclaringType().hasQualifiedName("java.io", "ByteArrayOutputStream") and
      (this.getName() = "toByteArray" or this.getName() = "toString")
    )
    or
    (
      this.getDeclaringType().hasQualifiedName("java.io", "ObjectInputStream") and
      this.getName().matches("read%")
    )
    or
    (
      (
        this.getDeclaringType().hasQualifiedName("java.lang", "StringBuilder") or
        this.getDeclaringType().hasQualifiedName("java.lang", "StringBuffer")
      ) and
      (this.getName() = "toString" or this.getName() = "append")
    )
    or
    (
      this.getDeclaringType().hasQualifiedName("javax.xml.transform.sax", "SAXSource") and
      this.hasName("getInputSource")
    )
    or
    (
      this.getDeclaringType().hasQualifiedName("javax.xml.transform.stream", "StreamSource") and
      this.hasName("getInputStream")
    )
  }
}

/**
 * Library methods that return tainted data if one of their arguments
 * is tainted.
 */
deprecated predicate dataPreservingArgument(Method method, int arg) {
  (
    method instanceof StringReplaceMethod and
    arg = 1
  )
  or
  (
    exists(Class c | c.getQualifiedName() = "java.lang.Number" |
      hasSubtypeStar(c, method.getDeclaringType())
    ) and
    (
      (method.getName().matches("parse%") and arg = 0)
      or
      (method.getName().matches("valueOf%") and arg = 0)
      or
      (method.getName().matches("to%String") and arg = 0)
    )
  )
  or
  (
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
  )
  or
  (
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
  )
  or
  (
    (method.getDeclaringType().hasQualifiedName("org.apache.commons.io", "IOUtils")) and
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
  )
  or
  (
    //A URI created from a tainted string is still tainted.
    method.getDeclaringType().hasQualifiedName("java.net", "URI") and
    method.hasName("create") and
    arg = 0
  )
  or
  (
    method.getDeclaringType().hasQualifiedName("javax.xml.transform.sax", "SAXSource") and
    method.hasName("sourceToInputSource") and
    arg = 0
  )
}

deprecated class StringReplaceMethod extends Method {
  StringReplaceMethod() {
    getDeclaringType() instanceof TypeString and
    (
      hasName("replace") or
      hasName("replaceAll") or
      hasName("replaceFirst")
    )
  }
}

deprecated predicate unsafeEscape(MethodAccess ma) {
  // Removing `<script>` tags using a string-replace method is
  // unsafe if such a tag is embedded inside another one (e.g. `<scr<script>ipt>`).
  exists(StringReplaceMethod m | ma.getMethod() = m |
    ma.getArgument(0).(StringLiteral).getRepresentedString() = "(<script>)" and
    ma.getArgument(1).(StringLiteral).getRepresentedString() = ""
  )
}

/**
 * DEPRECATED: Use semmle.code.java.dataflow.FlowSources.UserInput instead.
 *
 * Class for `tainted` user input.
 */
abstract deprecated class UserInput extends FlowSource { }

/**
 * DEPRECATED: Use semmle.code.java.dataflow.FlowSources.RemoteUserInput instead.
 *
 * Input that may be controlled by a remote user.
 */
deprecated class RemoteUserInput extends UserInput {
  RemoteUserInput() {
    this.(MethodAccess).getMethod() instanceof RemoteTaintedMethod
    or
    // Parameters to RMI methods.
    exists(RemoteCallableMethod method |
      method.getAParameter().getAnAccess() = this and
      (
        getType() instanceof PrimitiveType or
        getType() instanceof TypeString
      )
    )
    or
    // Parameters to Jax WS methods.
    exists(JaxWsEndpoint endpoint |
      endpoint.getARemoteMethod().getAParameter().getAnAccess() = this
    )
    or
    // Parameters to Jax Rs methods.
    exists(JaxRsResourceClass service |
      service.getAnInjectableCallable().getAParameter().getAnAccess() = this or
      service.getAnInjectableField().getAnAccess() = this
    )
    or
    // Reverse DNS. Try not to trigger on `localhost`.
    exists(MethodAccess m | m = this |
      m.getMethod() instanceof ReverseDNSMethod and
      not exists(MethodAccess l |
        (variableStep(l, m.getQualifier()) or l = m.getQualifier()) and
        l.getMethod().getName() = "getLocalHost"
      )
    )
    or
    //MessageBodyReader
    exists(MessageBodyReaderRead m |
      m.getParameter(4).getAnAccess() = this or
      m.getParameter(5).getAnAccess() = this
    )
  }
}

/**
 * DEPRECATED: Use semmle.code.java.dataflow.FlowSources.LocalUserInput instead.
 *
 * Input that may be controlled by a local user.
 */
abstract deprecated class LocalUserInput extends UserInput { }

deprecated class EnvInput extends LocalUserInput {
  EnvInput() {
    // Parameters to a main method.
    exists(MainMethod main | this = main.getParameter(0).getAnAccess())
    or
    // Args4j arguments.
    exists(Field f | this = f.getAnAccess() |
      f.getAnAnnotation().getType().getQualifiedName() = "org.kohsuke.args4j.Argument"
    )
    or
    // Results from various specific methods.
    this.(MethodAccess).getMethod() instanceof EnvTaintedMethod
    or
    // Access to `System.in`.
    exists(Field f | this = f.getAnAccess() | f instanceof SystemIn)
    or
    // Access to files.
    this.(ConstructorCall).getConstructedType().hasQualifiedName("java.io", "FileInputStream")
  }
}

deprecated class DatabaseInput extends LocalUserInput {
  DatabaseInput() { this.(MethodAccess).getMethod() instanceof ResultSetGetStringMethod }
}

deprecated library class RemoteTaintedMethod extends Method {
  RemoteTaintedMethod() {
    this instanceof ServletRequestGetParameterMethod or
    this instanceof HttpServletRequestGetQueryStringMethod or
    this instanceof HttpServletRequestGetHeaderMethod or
    this instanceof HttpServletRequestGetPathMethod or
    this instanceof ServletRequestGetBodyMethod or
    this instanceof CookieGetValueMethod or
    this instanceof URLConnectionGetInputStreamMethod or
    this instanceof SocketGetInputStreamMethod or
    this instanceof ApacheHttpGetParams or
    this instanceof ApacheHttpEntityGetContent or
    // In the setting of Android we assume that XML has been transmitted over
    // the network, so may be tainted.
    this instanceof XmlPullGetMethod or
    this instanceof XmlAttrSetGetMethod or
    // The current URL in a browser may be untrusted or uncontrolled.
    this instanceof WebViewGetUrlMethod
  }
}

deprecated library class EnvTaintedMethod extends Method {
  EnvTaintedMethod() {
    this instanceof MethodSystemGetenv or
    this instanceof PropertiesGetPropertyMethod or
    this instanceof MethodSystemGetProperty
  }
}

deprecated class TypeInetAddr extends RefType {
  TypeInetAddr() { this.getQualifiedName() = "java.net.InetAddress" }
}

deprecated class ReverseDNSMethod extends Method {
  ReverseDNSMethod() {
    this.getDeclaringType() instanceof TypeInetAddr and
    (
      this.getName() = "getHostName" or
      this.getName() = "getCanonicalHostName"
    )
  }
}
