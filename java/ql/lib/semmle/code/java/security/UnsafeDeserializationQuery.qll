/**
 * Provides classes and predicates for finding deserialization vulnerabilities.
 */

import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dispatch.VirtualDispatch
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
private import semmle.code.java.frameworks.Jms
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

/**
 * A type extending `ObjectInputStream` that makes it safe to deserialize untrusted data.
 *
 * * See https://commons.apache.org/proper/commons-io/javadocs/api-2.5/org/apache/commons/io/serialization/ValidatingObjectInputStream.html
 * * See https://github.com/ikkisoft/SerialKiller
 */
private class SafeObjectInputStreamType extends RefType {
  SafeObjectInputStreamType() {
    this.getASourceSupertype*()
        .hasQualifiedName("org.apache.commons.io.serialization", "ValidatingObjectInputStream") or
    this.getASourceSupertype*().hasQualifiedName("org.nibblesec.tools", "SerialKiller")
  }
}

private class XmlDecoderReadObjectMethod extends Method {
  XmlDecoderReadObjectMethod() {
    this.getDeclaringType().hasQualifiedName("java.beans", "XMLDecoder") and
    this.hasName("readObject")
  }
}

private module SafeXStreamConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    any(XStreamEnableWhiteListing ma).getQualifier().(VarAccess).getVariable().getAnAccess() =
      src.asExpr()
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod() instanceof XStreamReadObjectMethod
    )
  }
}

private module SafeXStreamFlow = DataFlow::Global<SafeXStreamConfig>;

private module SafeKryoConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    any(KryoEnableWhiteListing ma).getQualifier().(VarAccess).getVariable().getAnAccess() =
      src.asExpr()
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod() instanceof KryoReadObjectMethod
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    stepKryoPoolBuilderFactoryArgToConstructor(node1, node2) or
    stepKryoPoolRunMethodCallQualifierToFunctionalArgument(node1, node2) or
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
  private predicate stepKryoPoolRunMethodCallQualifierToFunctionalArgument(
    DataFlow::Node node1, DataFlow::Node node2
  ) {
    exists(MethodCall ma |
      ma.getMethod() instanceof KryoPoolRunMethod and
      node1.asExpr() = ma.getQualifier() and
      ma.getArgument(0).(FunctionalExpr).asMethod().getParameter(0) = node2.asParameter()
    )
  }

  /**
   * Holds when a `KryoPool.Builder` method is called fluently.
   */
  private predicate stepKryoPoolBuilderChainMethod(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall ma |
      ma.getMethod() instanceof KryoPoolBuilderMethod and
      ma = node2.asExpr() and
      ma.getQualifier() = node1.asExpr()
    )
  }

  /**
   * Holds when a `KryoPool.borrow` method is called.
   */
  private predicate stepKryoPoolBorrowMethod(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall ma |
      ma.getMethod() =
        any(Method m | m.getDeclaringType() instanceof KryoPool and m.hasName("borrow")) and
      node1.asExpr() = ma.getQualifier() and
      node2.asExpr() = ma
    )
  }
}

private module SafeKryoFlow = DataFlow::Global<SafeKryoConfig>;

/**
 * Holds if `ma` is a call that deserializes data from `sink`.
 */
predicate unsafeDeserialization(MethodCall ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof ObjectInputStreamReadObjectMethod and
    sink = ma.getQualifier() and
    not exists(DataFlow::ExprNode node |
      node.getExpr() = sink and
      node.getTypeBound() instanceof SafeObjectInputStreamType
    )
    or
    m instanceof XmlDecoderReadObjectMethod and
    sink = ma.getQualifier()
    or
    m instanceof XStreamReadObjectMethod and
    sink = ma.getAnArgument() and
    not SafeXStreamFlow::flowToExpr(ma.getQualifier())
    or
    m instanceof KryoReadObjectMethod and
    sink = ma.getAnArgument() and
    not SafeKryoFlow::flowToExpr(ma.getQualifier())
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
      UnsafeTypeFlow::flowToExpr(ma.getAnArgument())
      or
      EnableJacksonDefaultTypingFlow::flowToExpr(ma.getQualifier())
      or
      hasArgumentWithUnsafeJacksonAnnotation(ma)
    ) and
    not SafeObjectMapperFlow::flowToExpr(ma.getQualifier())
    or
    m instanceof JabsorbUnmarshallMethod and
    sink = ma.getArgument(2) and
    UnsafeTypeFlow::flowToExpr(ma.getArgument(1))
    or
    m instanceof JabsorbFromJsonMethod and
    sink = ma.getArgument(0)
    or
    m instanceof JoddJsonParseMethod and
    sink = ma.getArgument(0) and
    (
      // User controls the target type for deserialization
      UnsafeTypeFlow::flowToExpr(ma.getArgument(1))
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
    UnsafeTypeFlow::flowToExpr(ma.getArgument(1))
    or
    m.getASourceOverriddenMethod*() instanceof ObjectMessageGetObjectMethod and
    sink = ma.getQualifier().getUnderlyingExpr() and
    // If we can see an implementation, we trust dataflow to find a path to the other sinks instead
    not exists(viableCallable(ma))
  )
}

/** A sink for unsafe deserialization. */
class UnsafeDeserializationSink extends ApiSinkNode, DataFlow::ExprNode {
  UnsafeDeserializationSink() { unsafeDeserialization(_, this.getExpr()) }

  /** Gets a call that triggers unsafe deserialization. */
  MethodCall getMethodCall() { unsafeDeserialization(result, this.getExpr()) }
}

/** Holds if `node` is a sanitizer for unsafe deserialization */
private predicate isUnsafeDeserializationSanitizer(DataFlow::Node node) {
  exists(ClassInstanceExpr cie |
    cie.getConstructor().getDeclaringType() instanceof JsonIoJsonReader and
    cie = node.asExpr() and
    SafeJsonIoFlow::flowToExpr(cie.getArgument(1))
  )
  or
  exists(MethodCall ma |
    ma.getMethod() instanceof JsonIoJsonToJavaMethod and
    ma.getArgument(0) = node.asExpr() and
    SafeJsonIoFlow::flowToExpr(ma.getArgument(1))
  )
  or
  exists(MethodCall ma |
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
  exists(MethodCall ma |
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

/** Taint step for Unsafe deserialization */
private predicate isUnsafeDeserializationTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
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
  exists(MethodCall ma |
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

/** Tracks flows from remote user input to a deserialization sink. */
private module UnsafeDeserializationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserializationSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    isUnsafeDeserializationTaintStep(pred, succ)
  }

  predicate isBarrier(DataFlow::Node node) { isUnsafeDeserializationSanitizer(node) }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module UnsafeDeserializationFlow = TaintTracking::Global<UnsafeDeserializationConfig>;

/**
 * Gets a safe usage of the `use` method of Flexjson, which could be:
 *     use(String, ...) where the path is null or
 *     use(ObjectFactory, String...) where the string varargs (or array) contains null
 */
MethodCall getASafeFlexjsonUseCall() {
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
  exists(ReflectiveClassIdentifierMethodCall ma |
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
  exists(MethodCall ma, Method m, Expr arg | m = ma.getMethod() and arg = ma.getAnArgument() |
    m.getReturnType() instanceof JacksonTypeDescriptorType and
    m.getName().regexpMatch("(?i).*(resolve|load|class|type).*") and
    arg.getType() instanceof TypeString and
    arg = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/** A sink representing an argument of a deserialization method */
private class UnsafeTypeSink extends DataFlow::Node {
  UnsafeTypeSink() {
    exists(MethodCall ma, int i, Expr arg | i > 0 and ma.getArgument(i) = arg |
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
      arg = this.asExpr()
    )
  }
}

private predicate isUnsafeTypeAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  resolveClassStep(fromNode, toNode) or
  looksLikeResolveClassStep(fromNode, toNode) or
  intentFlowsToParcel(fromNode, toNode)
}

/**
 * Tracks flow from a remote source to a type descriptor (e.g. a `java.lang.Class` instance)
 * passed to a deserialization method.
 *
 * If this is user-controlled, arbitrary code could be executed while instantiating the user-specified type.
 */
module UnsafeTypeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeTypeSink }

  /**
   * Holds if `fromNode` to `toNode` is a dataflow step that resolves a class
   * or at least looks like resolving a class.
   */
  predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    isUnsafeTypeAdditionalTaintStep(fromNode, toNode)
  }
}

/**
 * Tracks flow from a remote source to a type descriptor (e.g. a `java.lang.Class` instance)
 * passed to a deserialization method.
 *
 * If this is user-controlled, arbitrary code could be executed while instantiating the user-specified type.
 */
module UnsafeTypeFlow = TaintTracking::Global<UnsafeTypeConfig>;

private module EnableJacksonDefaultTypingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    any(EnableJacksonDefaultTyping ma).getQualifier() = src.asExpr()
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof ObjectMapperReadQualifier }
}

/**
 * Tracks flow from `enableDefaultTyping` calls to a subsequent Jackson deserialization method call.
 */
module EnableJacksonDefaultTypingFlow = DataFlow::Global<EnableJacksonDefaultTypingConfig>;

/** Dataflow step that creates an `ObjectMapper` via a builder. */
private predicate isObjectMapperBuilderAdditionalFlowStep(
  DataFlow::Node fromNode, DataFlow::Node toNode
) {
  exists(MethodCall ma, Method m | m = ma.getMethod() |
    m.getDeclaringType() instanceof MapperBuilder and
    m.getReturnType()
        .(RefType)
        .hasQualifiedName("com.fasterxml.jackson.databind.json",
          ["JsonMapper$Builder", "JsonMapper"]) and
    fromNode.asExpr() = ma.getQualifier() and
    ma = toNode.asExpr()
  )
}

/**
 * Tracks flow from calls that set a type validator to a subsequent Jackson deserialization method call,
 * including across builder method calls.
 *
 * Such a Jackson deserialization method call is safe because validation will likely prevent instantiating unexpected types.
 */
module SafeObjectMapperConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof SetPolymorphicTypeValidatorSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ObjectMapperReadQualifier }

  /**
   * Holds if `fromNode` to `toNode` is a dataflow step
   * that configures or creates an `ObjectMapper` via a builder.
   */
  predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    isObjectMapperBuilderAdditionalFlowStep(fromNode, toNode)
  }
}

/**
 * Tracks flow from calls that set a type validator to a subsequent Jackson deserialization method call,
 * including across builder method calls.
 *
 * Such a Jackson deserialization method call is safe because validation will likely prevent instantiating unexpected types.
 */
module SafeObjectMapperFlow = DataFlow::Global<SafeObjectMapperConfig>;

/**
 * A method that configures Jodd's JsonParser, either enabling dangerous deserialization to
 * arbitrary Java types or restricting the types that can be instantiated.
 */
private class JoddJsonParserConfigurationMethodQualifier extends DataFlow::ExprNode {
  JoddJsonParserConfigurationMethodQualifier() {
    exists(MethodCall ma, Method m | ma.getQualifier() = this.asExpr() and m = ma.getMethod() |
      m instanceof WithClassMetadataMethod
      or
      m instanceof SetClassMetadataNameMethod
      or
      m instanceof AllowClassMethod
    )
  }
}

private module JoddJsonParserConfigurationMethodConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    src instanceof JoddJsonParserConfigurationMethodQualifier
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      ma.getMethod() instanceof JoddJsonParseMethod and
      sink.asExpr() = ma.getQualifier() // The class type argument
    )
  }
}

/**
 * Configuration tracking flow from methods that configure `jodd.json.JsonParser`'s class
 * instantiation feature to a `.parse` call on the same parser.
 */
private module JoddJsonParserConfigurationMethodFlow =
  DataFlow::Global<JoddJsonParserConfigurationMethodConfig>;

/**
 * Gets the qualifier to a method call that configures a `jodd.json.JsonParser` instance unsafely.
 *
 * Such a parser may instantiate an arbtirary type when deserializing untrusted data.
 */
private DataFlow::Node getAnUnsafelyConfiguredParser() {
  exists(MethodCall ma | result.asExpr() = ma.getQualifier() |
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
  exists(MethodCall ma | result.asExpr() = ma.getQualifier() |
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
  exists(DataFlow::Node parser | parser.asExpr() = parserExpr |
    JoddJsonParserConfigurationMethodFlow::flow(getAnUnsafelyConfiguredParser(), parser) and
    not JoddJsonParserConfigurationMethodFlow::flow(getASafelyConfiguredParser(), parser)
  )
}
