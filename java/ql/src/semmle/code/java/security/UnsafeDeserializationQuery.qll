/**
 * Provides classes and predicates for finding deserialization vulnerabilities.
 */

import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking2
private import semmle.code.java.frameworks.Kryo
private import semmle.code.java.frameworks.XStream
private import semmle.code.java.frameworks.SnakeYaml
private import semmle.code.java.frameworks.FastJson
private import semmle.code.java.frameworks.JYaml
private import semmle.code.java.frameworks.JsonIo
private import semmle.code.java.frameworks.YamlBeans
private import semmle.code.java.frameworks.HessianBurlap
private import semmle.code.java.frameworks.Castor
private import semmle.code.java.frameworks.Jackson
private import semmle.code.java.frameworks.Jabsorb
private import semmle.code.java.frameworks.apache.Lang
private import semmle.code.java.Reflection

private class ObjectInputStreamReadObjectMethod extends Method {
  ObjectInputStreamReadObjectMethod() {
    this.getDeclaringType().getASourceSupertype*().hasQualifiedName("java.io", "ObjectInputStream") and
    (this.hasName("readObject") or this.hasName("readUnshared"))
  }
}

private class XMLDecoderReadObjectMethod extends Method {
  XMLDecoderReadObjectMethod() {
    this.getDeclaringType().hasQualifiedName("java.beans", "XMLDecoder") and
    this.hasName("readObject")
  }
}

private class SafeXStream extends DataFlow2::Configuration {
  SafeXStream() { this = "UnsafeDeserialization::SafeXStream" }

  override predicate isSource(DataFlow::Node src) {
    any(XStreamEnableWhiteListing ma).getQualifier().(VarAccess).getVariable().getAnAccess() =
      src.asExpr()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod() instanceof XStreamReadObjectMethod
    )
  }
}

private class SafeKryo extends DataFlow2::Configuration {
  SafeKryo() { this = "UnsafeDeserialization::SafeKryo" }

  override predicate isSource(DataFlow::Node src) {
    any(KryoEnableWhiteListing ma).getQualifier().(VarAccess).getVariable().getAnAccess() =
      src.asExpr()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod() instanceof KryoReadObjectMethod
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    stepKryoPoolBuilderFactoryArgToConstructor(node1, node2) or
    stepKryoPoolRunMethodAccessQualifierToFunctionalArgument(node1, node2) or
    stepKryoPoolBuilderChainMethod(node1, node2) or
    stepKryoPoolBorrowMethod(node1, node2)
  }

  /**
   * Holds when a functional expression is used to create a `KryoPool.Builder`.
   * Eg. `new KryoPool.Builder(() -> new Kryo())`
   */
  private predicate stepKryoPoolBuilderFactoryArgToConstructor(
    DataFlow::Node node1, DataFlow::Node node2
  ) {
    exists(ConstructorCall cc, FunctionalExpr fe |
      cc.getConstructedType() instanceof KryoPoolBuilder and
      fe.asMethod().getBody().getAStmt().(ReturnStmt).getResult() = node1.asExpr() and
      node2.asExpr() = cc and
      cc.getArgument(0) = fe
    )
  }

  /**
   * Holds when a `KryoPool.run` is called to use a `Kryo` instance.
   * Eg. `pool.run(kryo -> ...)`
   */
  private predicate stepKryoPoolRunMethodAccessQualifierToFunctionalArgument(
    DataFlow::Node node1, DataFlow::Node node2
  ) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KryoPoolRunMethod and
      node1.asExpr() = ma.getQualifier() and
      ma.getArgument(0).(FunctionalExpr).asMethod().getParameter(0) = node2.asParameter()
    )
  }

  /**
   * Holds when a `KryoPool.Builder` method is called fluently.
   */
  private predicate stepKryoPoolBuilderChainMethod(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KryoPoolBuilderMethod and
      ma = node2.asExpr() and
      ma.getQualifier() = node1.asExpr()
    )
  }

  /**
   * Holds when a `KryoPool.borrow` method is called.
   */
  private predicate stepKryoPoolBorrowMethod(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma |
      ma.getMethod() =
        any(Method m | m.getDeclaringType() instanceof KryoPool and m.hasName("borrow")) and
      node1.asExpr() = ma.getQualifier() and
      node2.asExpr() = ma
    )
  }
}

/**
 * Holds if `ma` is a call that deserializes data from `sink`.
 */
predicate unsafeDeserialization(MethodAccess ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof ObjectInputStreamReadObjectMethod and
    sink = ma.getQualifier() and
    not exists(DataFlow::ExprNode node |
      node.getExpr() = sink and
      node.getTypeBound()
          .(RefType)
          .hasQualifiedName("org.apache.commons.io.serialization", "ValidatingObjectInputStream")
    )
    or
    m instanceof XMLDecoderReadObjectMethod and
    sink = ma.getQualifier()
    or
    m instanceof XStreamReadObjectMethod and
    sink = ma.getAnArgument() and
    not exists(SafeXStream sxs | sxs.hasFlowToExpr(ma.getQualifier()))
    or
    m instanceof KryoReadObjectMethod and
    sink = ma.getAnArgument() and
    not exists(SafeKryo sk | sk.hasFlowToExpr(ma.getQualifier()))
    or
    m instanceof MethodApacheSerializationUtilsDeserialize and
    sink = ma.getArgument(0)
    or
    ma instanceof UnsafeSnakeYamlParse and
    sink = ma.getArgument(0)
    or
    ma.getMethod() instanceof FastJsonParseMethod and
    not fastJsonLooksSafe() and
    sink = ma.getArgument(0)
    or
    ma.getMethod() instanceof JYamlLoaderUnsafeLoadMethod and
    sink = ma.getArgument(0)
    or
    ma.getMethod() instanceof JsonIoJsonToJavaMethod and
    sink = ma.getArgument(0)
    or
    ma.getMethod() instanceof JsonIoReadObjectMethod and
    sink = ma.getQualifier()
    or
    ma.getMethod() instanceof YamlBeansReaderReadMethod and sink = ma.getQualifier()
    or
    ma.getMethod() instanceof UnsafeHessianInputReadObjectMethod and sink = ma.getQualifier()
    or
    ma.getMethod() instanceof CastorUnmarshalMethod and sink = ma.getAnArgument()
    or
    ma.getMethod() instanceof BurlapInputReadObjectMethod and sink = ma.getQualifier()
    or
    ma.getMethod() instanceof ObjectMapperReadMethod and
    sink = ma.getArgument(0) and
    (
      exists(UnsafeTypeConfig config | config.hasFlowToExpr(ma.getAnArgument()))
      or
      exists(EnableJacksonDefaultTypingConfig config | config.hasFlowToExpr(ma.getQualifier()))
      or
      hasArgumentWithUnsafeJacksonAnnotation(ma)
    ) and
    not exists(SafeObjectMapperConfig config | config.hasFlowToExpr(ma.getQualifier()))
    or
    m instanceof JabsorbUnmarshallMethod and
    sink = ma.getArgument(2) and
    any(UnsafeTypeConfig config).hasFlowToExpr(ma.getArgument(1))
    or
    m instanceof JabsorbFromJsonMethod and
    sink = ma.getArgument(0)
  )
}

/** A sink for unsafe deserialization. */
class UnsafeDeserializationSink extends DataFlow::ExprNode {
  UnsafeDeserializationSink() { unsafeDeserialization(_, this.getExpr()) }

  /** Gets a call that triggers unsafe deserialization. */
  MethodAccess getMethodAccess() { unsafeDeserialization(result, this.getExpr()) }
}

/**
 * Tracks flows from remote user input to a deserialization sink.
 */
class UnsafeDeserializationConfig extends TaintTracking::Configuration {
  UnsafeDeserializationConfig() { this = "UnsafeDeserializationConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserializationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(ClassInstanceExpr cie |
      cie.getArgument(0) = pred.asExpr() and
      cie = succ.asExpr() and
      (
        cie.getConstructor().getDeclaringType() instanceof JsonIoJsonReader or
        cie.getConstructor().getDeclaringType() instanceof YamlBeansReader or
        cie.getConstructor().getDeclaringType().getASupertype*() instanceof UnsafeHessianInput or
        cie.getConstructor().getDeclaringType() instanceof BurlapInput
      )
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof BurlapInputInitMethod and
      ma.getArgument(0) = pred.asExpr() and
      ma.getQualifier() = succ.asExpr()
    )
    or
    createJacksonJsonParserStep(pred, succ)
    or
    createJacksonTreeNodeStep(pred, succ)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(ClassInstanceExpr cie |
      cie.getConstructor().getDeclaringType() instanceof JsonIoJsonReader and
      cie = node.asExpr() and
      exists(SafeJsonIoConfig sji | sji.hasFlowToExpr(cie.getArgument(1)))
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof JsonIoJsonToJavaMethod and
      ma.getArgument(0) = node.asExpr() and
      exists(SafeJsonIoConfig sji | sji.hasFlowToExpr(ma.getArgument(1)))
    )
  }
}

/** Holds if `fromNode` to `toNode` is a dataflow step that resolves a class. */
predicate resolveClassStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(ReflectiveClassIdentifierMethodAccess ma |
    ma.getArgument(0) = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that looks like resolving a class.
 * A method probably resolves a class if it takes a string, returns a type descriptor,
 * and its name contains "resolve", "load", etc.
 *
 * Any method call that satisfies the rule above is assumed to propagate taint from its string arguments,
 * so methods that accept user-controlled data but sanitize it or use it for some
 * completely different purpose before returning a type descriptor could result in false positives.
 */
predicate looksLikeResolveClassStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m, Expr arg | m = ma.getMethod() and arg = ma.getAnArgument() |
    m.getReturnType() instanceof JacksonTypeDescriptorType and
    m.getName().toLowerCase().regexpMatch("(?i).*(resolve|load|class|type).*") and
    arg.getType() instanceof TypeString and
    arg = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/**
 * Tracks flow from a remote source to a type descriptor (e.g. a `java.lang.Class` instance)
 * passed to a deserialization method.
 *
 * If this is user-controlled, arbitrary code could be executed while instantiating the user-specified type.
 */
class UnsafeTypeConfig extends TaintTracking2::Configuration {
  UnsafeTypeConfig() { this = "UnsafeTypeConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, int i, Expr arg | i > 0 and ma.getArgument(i) = arg |
      (
        ma.getMethod() instanceof ObjectMapperReadMethod
        or
        ma.getMethod() instanceof JabsorbUnmarshallMethod
      ) and
      // Note `JacksonTypeDescriptorType` includes plain old `java.lang.Class`
      arg.getType() instanceof JacksonTypeDescriptorType and
      arg = sink.asExpr()
    )
  }

  /**
   * Holds if `fromNode` to `toNode` is a dataflow step that resolves a class
   * or at least looks like resolving a class.
   */
  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    resolveClassStep(fromNode, toNode) or
    looksLikeResolveClassStep(fromNode, toNode)
  }
}

/**
 * Tracks flow from `enableDefaultTyping` calls to a subsequent Jackson deserialization method call.
 */
class EnableJacksonDefaultTypingConfig extends DataFlow2::Configuration {
  EnableJacksonDefaultTypingConfig() { this = "EnableJacksonDefaultTypingConfig" }

  override predicate isSource(DataFlow::Node src) {
    any(EnableJacksonDefaultTyping ma).getQualifier() = src.asExpr()
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ObjectMapperReadQualifier }
}

/**
 * Tracks flow from calls that set a type validator to a subsequent Jackson deserialization method call,
 * including across builder method calls.
 *
 * Such a Jackson deserialization method call is safe because validation will likely prevent instantiating unexpected types.
 */
class SafeObjectMapperConfig extends DataFlow2::Configuration {
  SafeObjectMapperConfig() { this = "SafeObjectMapperConfig" }

  override predicate isSource(DataFlow::Node src) {
    src instanceof SetPolymorphicTypeValidatorSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ObjectMapperReadQualifier }

  /**
   * Holds if `fromNode` to `toNode` is a dataflow step
   * that configures or creates an `ObjectMapper` via a builder.
   */
  override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.getDeclaringType() instanceof MapperBuilder and
      m.getReturnType()
          .(RefType)
          .hasQualifiedName("com.fasterxml.jackson.databind.json",
            ["JsonMapper$Builder", "JsonMapper"]) and
      fromNode.asExpr() = ma.getQualifier() and
      ma = toNode.asExpr()
    )
  }
}
