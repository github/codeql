import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.frameworks.Kryo
import semmle.code.java.frameworks.XStream
import semmle.code.java.frameworks.SnakeYaml
import semmle.code.java.frameworks.FastJson
import semmle.code.java.frameworks.JYaml
import semmle.code.java.frameworks.JsonIo
import semmle.code.java.frameworks.YamlBeans
import semmle.code.java.frameworks.HessianBurlap
import semmle.code.java.frameworks.Castor
import semmle.code.java.frameworks.apache.Lang
import semmle.code.java.Reflection

class ObjectInputStreamReadObjectMethod extends Method {
  ObjectInputStreamReadObjectMethod() {
    this.getDeclaringType().getASourceSupertype*().hasQualifiedName("java.io", "ObjectInputStream") and
    (this.hasName("readObject") or this.hasName("readUnshared"))
  }
}

class XMLDecoderReadObjectMethod extends Method {
  XMLDecoderReadObjectMethod() {
    this.getDeclaringType().hasQualifiedName("java.beans", "XMLDecoder") and
    this.hasName("readObject")
  }
}

private class ObjectMapperReadMethod extends Method {
  ObjectMapperReadMethod() {
    this.getDeclaringType() instanceof ObjectMapper and
    this.hasName(["readValue", "readValues", "treeToValue"])
  }
}

private class ObjectMapper extends RefType {
  ObjectMapper() {
    getASupertype*().hasQualifiedName("com.fasterxml.jackson.databind", "ObjectMapper")
  }
}

private class MapperBuilder extends RefType {
  MapperBuilder() {
    hasQualifiedName("com.fasterxml.jackson.databind.cfg", "MapperBuilder<JsonMapper,Builder>")
  }
}

private class JsonFactory extends RefType {
  JsonFactory() { hasQualifiedName("com.fasterxml.jackson.core", "JsonFactory") }
}

private class JsonParser extends RefType {
  JsonParser() { hasQualifiedName("com.fasterxml.jackson.core", "JsonParser") }
}

private class JacksonTypeDescriptorType extends RefType {
  JacksonTypeDescriptorType() {
    this instanceof TypeClass or
    hasQualifiedName("com.fasterxml.jackson.databind", "JavaType") or
    hasQualifiedName("com.fasterxml.jackson.core.type", "TypeReference")
  }
}

private class EnableJacksonDefaultTyping extends MethodAccess {
  EnableJacksonDefaultTyping() {
    this.getMethod().getDeclaringType() instanceof ObjectMapper and
    this.getMethod().hasName("enableDefaultTyping")
  }
}

private class ObjectMapperReadSink extends DataFlow::ExprNode {
  ObjectMapperReadSink() {
    exists(MethodAccess ma | ma.getQualifier() = this.asExpr() |
      ma.getMethod() instanceof ObjectMapperReadMethod
    )
  }
}

private class SetPolymorphicTypeValidatorSource extends DataFlow::ExprNode {
  SetPolymorphicTypeValidatorSource() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      (
        m.getDeclaringType() instanceof ObjectMapper and
        m.hasName("setPolymorphicTypeValidator")
        or
        m.getDeclaringType() instanceof MapperBuilder and
        m.hasName("polymorphicTypeValidator")
      ) and
      this.asExpr() = ma.getQualifier()
    )
  }
}

class SafeXStream extends DataFlow2::Configuration {
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

class SafeKryo extends DataFlow2::Configuration {
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
 * Tracks flow from `enableDefaultTyping` calls to a subsequent Jackson deserialization method call.
 */
private class EnableJacksonDefaultTypingConfig extends DataFlow2::Configuration {
  EnableJacksonDefaultTypingConfig() { this = "EnableJacksonDefaultTypingConfig" }

  override predicate isSource(DataFlow::Node src) {
    any(EnableJacksonDefaultTyping ma).getQualifier() = src.asExpr()
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ObjectMapperReadSink }
}

/**
 * Tracks flow from calls which set a type validator to a subsequent Jackson deserialization method call,
 * including across builder method calls.
 *
 * Such a Jackson deserialization method call is safe because validation will likely prevent instantiating unexpected types.
 */
private class SafeObjectMapperConfig extends DataFlow2::Configuration {
  SafeObjectMapperConfig() { this = "SafeObjectMapperConfig" }

  override predicate isSource(DataFlow::Node src) {
    src instanceof SetPolymorphicTypeValidatorSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ObjectMapperReadSink }

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
 * Tracks flow from a remote source to a type descriptor (e.g. a `java.lang.Class` instance)
 * passed to a Jackson deserialization method.
 *
 * If this is user-controlled, arbitrary code could be executed while instantiating the user-specified type.
 */
private class UnsafeTypeConfig extends TaintTracking2::Configuration {
  UnsafeTypeConfig() { this = "UnsafeTypeConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, int i, Expr arg | i > 0 and ma.getArgument(i) = arg |
      ma.getMethod() instanceof ObjectMapperReadMethod and
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
 * Holds if `fromNode` to `toNode` is a dataflow step that resolves a class.
 */
private predicate resolveClassStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(ReflectiveClassIdentifierMethodAccess ma |
    ma.getArgument(0) = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that looks like resolving a class.
 * A method probably resolves a class if it is external, takes a string, returns a type descriptor
 * and its name contains "resolve", "load", etc.
 *
 * Any method call that satisfies the rule above is assumed to propagate taint from its string arguments,
 * so methods that accept user-controlled data but sanitize it or use it for some
 * completely different purpose before returning a type descriptor could result in false positives.
 */
private predicate looksLikeResolveClassStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m, int i, Expr arg |
    m = ma.getMethod() and arg = ma.getArgument(i)
  |
    m.getReturnType() instanceof JacksonTypeDescriptorType and
    m.getName().toLowerCase().regexpMatch("resolve|load|class|type") and
    arg.getType() instanceof TypeString and
    arg = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that creates a Jackson parser.
 *
 * For example, a `createParser(userString)` call yields a `JsonParser` which becomes dangerous
 * if passed to an unsafely-configured `ObjectMapper`'s `readValue` method.
 */
predicate createJacksonJsonParserStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    (m.getDeclaringType() instanceof ObjectMapper or m.getDeclaringType() instanceof JsonFactory) and
    m.hasName("createParser") and
    ma.getArgument(0) = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that creates a Jackson `TreeNode`.
 *
 * These are parse trees of user-supplied JSON, which may lead to arbitrary code execution
 * if passed to an unsafely-configured `ObjectMapper`'s `treeToValue` method.
 */
predicate createJacksonTreeNodeStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m.getDeclaringType() instanceof ObjectMapper and
    m.hasName("readTree") and
    ma.getArgument(0) = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
  or
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m.getDeclaringType() instanceof JsonParser and
    m.hasName("readValueAsTree") and
    ma.getQualifier() = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/**
 * Holds if `type` or one of its supertypes has a field with `JsonTypeInfo` annotation
 * that enables polymorphic type handling.
 */
private predicate hasJsonTypeInfoAnnotation(RefType type) {
  hasFieldWithJsonTypeAnnotation(type.getASupertype*()) or
  hasFieldWithJsonTypeAnnotation(type.getAField().getType())
}

/**
 * Holds if `type` has a field with `JsonTypeInfo` annotation
 * that enables polymorphic type handling.
 */
private predicate hasFieldWithJsonTypeAnnotation(RefType type) {
  exists(Annotation a |
    type.getAField().getAnAnnotation() = a and
    a.getType().hasQualifiedName("com.fasterxml.jackson.annotation", "JsonTypeInfo") and
    a.getValue("use").(VarAccess).getVariable().hasName(["CLASS", "MINIMAL_CLASS"])
  )
}

/**
 * Holds if `call` is a method call to a Jackson deserialization method such as `ObjectMapper.readValue(String, Class)`,
 * and the target deserialized class has a field with a `JsonTypeInfo` annotation that enables polymorphic typing.
 */
private predicate hasArgumentWithUnsafeJacksonAnnotation(MethodAccess call) {
  call.getMethod() instanceof ObjectMapperReadMethod and
  exists(RefType argType, int i | i > 0 and argType = call.getArgument(i).getType() |
    hasJsonTypeInfoAnnotation(argType.(ParameterizedType).getATypeArgument())
  )
}

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
  )
}

class UnsafeDeserializationSink extends DataFlow::ExprNode {
  UnsafeDeserializationSink() { unsafeDeserialization(_, this.getExpr()) }

  MethodAccess getMethodAccess() { unsafeDeserialization(result, this.getExpr()) }
}
