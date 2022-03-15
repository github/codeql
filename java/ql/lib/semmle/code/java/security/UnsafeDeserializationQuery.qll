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
private import semmle.code.java.frameworks.JoddJson
private import semmle.code.java.frameworks.Flexjson
private import semmle.code.java.frameworks.google.Gson
private import semmle.code.java.frameworks.apache.Lang
private import semmle.code.java.Reflection

private class ObjectInputStreamReadObjectMethod extends Method {
  ObjectInputStreamReadObjectMethod() {
    this.getDeclaringType().getASourceSupertype*() instanceof TypeObjectInputStream and
    (this.hasName("readObject") or this.hasName("readUnshared"))
  }
}

private class XmlDecoderReadObjectMethod extends Method {
  XmlDecoderReadObjectMethod() {
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
    this.stepKryoPoolBuilderFactoryArgToConstructor(node1, node2) or
    this.stepKryoPoolRunMethodAccessQualifierToFunctionalArgument(node1, node2) or
    this.stepKryoPoolBuilderChainMethod(node1, node2) or
    this.stepKryoPoolBorrowMethod(node1, node2)
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
    m instanceof XmlDecoderReadObjectMethod and
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
    or
    m instanceof JoddJsonParseMethod and
    sink = ma.getArgument(0) and
    (
      // User controls the target type for deserialization
      any(UnsafeTypeConfig c).hasFlowToExpr(ma.getArgument(1))
      or
      // jodd.json.JsonParser may be configured for unrestricted deserialization to user-specified types
      joddJsonParserConfiguredUnsafely(ma.getQualifier())
    )
    or
    m instanceof FlexjsonDeserializeMethod and
    sink = ma.getArgument(0)
    or
    m instanceof GsonDeserializeMethod and
    sink = ma.getArgument(0) and
    any(UnsafeTypeConfig config).hasFlowToExpr(ma.getArgument(1))
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
        cie.getConstructor().getDeclaringType().getAnAncestor() instanceof UnsafeHessianInput or
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
    or
    intentFlowsToParcel(pred, succ)
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
    or
    exists(MethodAccess ma |
      // Sanitize the input to jodd.json.JsonParser.parse et al whenever it appears
      // to be called with an explicit class argument limiting those types that can
      // be instantiated during deserialization.
      ma.getMethod() instanceof JoddJsonParseMethod and
      ma.getArgument(1).getType() instanceof TypeClass and
      not ma.getArgument(1) instanceof NullLiteral and
      not ma.getArgument(1).getType().getName() = ["Class<Object>", "Class<?>"] and
      node.asExpr() = ma.getAnArgument()
    )
    or
    exists(MethodAccess ma |
      // Sanitize the input to flexjson.JSONDeserializer.deserialize whenever it appears
      // to be called with an explicit class argument limiting those types that can
      // be instantiated during deserialization, or if the deserializer has already been
      // configured to use a specified root class.
      ma.getMethod() instanceof FlexjsonDeserializeMethod and
      node.asExpr() = ma.getAnArgument() and
      (
        ma.getArgument(1).getType() instanceof TypeClass and
        not ma.getArgument(1) instanceof NullLiteral and
        not ma.getArgument(1).getType().getName() = ["Class<Object>", "Class<?>"]
        or
        isSafeFlexjsonDeserializer(ma.getQualifier())
      )
    )
  }
}

/**
 * Gets a safe usage of the `use` method of Flexjson, which could be:
 *     use(String, ...) where the path is null or
 *     use(ObjectFactory, String...) where the string varargs (or array) contains null
 */
MethodAccess getASafeFlexjsonUseCall() {
  result.getMethod() instanceof FlexjsonDeserializerUseMethod and
  (
    result.getMethod().getParameterType(0) instanceof TypeString and
    result.getArgument(0) instanceof NullLiteral
    or
    result.getMethod().getParameterType(0) instanceof FlexjsonObjectFactory and
    result.getAnArgument() instanceof NullLiteral
  )
}

/**
 * Holds if `e` is a safely configured Flexjson `JSONDeserializer`.
 */
predicate isSafeFlexjsonDeserializer(Expr e) {
  DataFlow::localExprFlow(getASafeFlexjsonUseCall().getQualifier(), e)
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
    m.getName().regexpMatch("(?i).*(resolve|load|class|type).*") and
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
        or
        ma.getMethod() instanceof JoddJsonParseMethod
        or
        ma.getMethod() instanceof GsonDeserializeMethod
      ) and
      // Note `JacksonTypeDescriptorType` includes plain old `java.lang.Class`
      (
        arg.getType() instanceof JacksonTypeDescriptorType
        or
        arg.getType().(RefType).hasQualifiedName("java.lang.reflect", "Type")
      ) and
      arg = sink.asExpr()
    )
  }

  /**
   * Holds if `fromNode` to `toNode` is a dataflow step that resolves a class
   * or at least looks like resolving a class.
   */
  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    resolveClassStep(fromNode, toNode) or
    looksLikeResolveClassStep(fromNode, toNode) or
    intentFlowsToParcel(fromNode, toNode)
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

/**
 * A method that configures Jodd's JsonParser, either enabling dangerous deserialization to
 * arbitrary Java types or restricting the types that can be instantiated.
 */
private class JoddJsonParserConfigurationMethodQualifier extends DataFlow::ExprNode {
  JoddJsonParserConfigurationMethodQualifier() {
    exists(MethodAccess ma, Method m | ma.getQualifier() = this.asExpr() and m = ma.getMethod() |
      m instanceof WithClassMetadataMethod
      or
      m instanceof SetClassMetadataNameMethod
      or
      m instanceof AllowClassMethod
    )
  }
}

/**
 * Configuration tracking flow from methods that configure `jodd.json.JsonParser`'s class
 * instantiation feature to a `.parse` call on the same parser.
 */
private class JoddJsonParserConfigurationMethodConfig extends DataFlow2::Configuration {
  JoddJsonParserConfigurationMethodConfig() {
    this = "UnsafeDeserialization::JoddJsonParserConfigurationMethodConfig"
  }

  override predicate isSource(DataFlow::Node src) {
    src instanceof JoddJsonParserConfigurationMethodQualifier
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof JoddJsonParseMethod and
      sink.asExpr() = ma.getQualifier() // The class type argument
    )
  }
}

/**
 * Gets the qualifier to a method call that configures a `jodd.json.JsonParser` instance unsafely.
 *
 * Such a parser may instantiate an arbtirary type when deserializing untrusted data.
 */
private DataFlow::Node getAnUnsafelyConfiguredParser() {
  exists(MethodAccess ma | result.asExpr() = ma.getQualifier() |
    ma.getMethod() instanceof WithClassMetadataMethod and
    ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true
    or
    ma.getMethod() instanceof SetClassMetadataNameMethod and
    not ma.getArgument(0) instanceof NullLiteral
  )
}

/**
 * Gets the qualifier to a method call that configures a `jodd.json.JsonParser` instance safely.
 *
 * Such a parser will not instantiate an arbtirary type when deserializing untrusted data.
 */
private DataFlow::Node getASafelyConfiguredParser() {
  exists(MethodAccess ma | result.asExpr() = ma.getQualifier() |
    ma.getMethod() instanceof WithClassMetadataMethod and
    ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = false
    or
    ma.getMethod() instanceof SetClassMetadataNameMethod and
    ma.getArgument(0) instanceof NullLiteral
    or
    ma.getMethod() instanceof AllowClassMethod
  )
}

/**
 * Holds if `parseMethodQualifierExpr` is a `jodd.json.JsonParser` instance that is configured unsafely
 * and which never appears to be configured safely.
 */
private predicate joddJsonParserConfiguredUnsafely(Expr parserExpr) {
  exists(DataFlow::Node parser, JoddJsonParserConfigurationMethodConfig config |
    parser.asExpr() = parserExpr
  |
    config.hasFlow(getAnUnsafelyConfiguredParser(), parser) and
    not config.hasFlow(getASafelyConfiguredParser(), parser)
  )
}
