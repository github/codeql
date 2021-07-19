/**
 * Provides classes and predicates for working with the Jackson serialization framework.
 */

import java
import semmle.code.java.Reflection
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2

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

/** Methods in `ObjectMapper` that deserialize data. */
class ObjectMapperReadMethod extends Method {
  ObjectMapperReadMethod() {
    this.getDeclaringType() instanceof ObjectMapper and
    this.hasName(["readValue", "readValues", "treeToValue"])
  }
}

/** A call that enables the default typing in `ObjectMapper`. */
private class EnableJacksonDefaultTyping extends MethodAccess {
  EnableJacksonDefaultTyping() {
    this.getMethod().getDeclaringType() instanceof ObjectMapper and
    this.getMethod().hasName("enableDefaultTyping")
  }
}

/** A qualifier of a call to one of the methods in `ObjectMapper` that deserialize data. */
private class ObjectMapperReadQualifier extends DataFlow::ExprNode {
  ObjectMapperReadQualifier() {
    exists(MethodAccess ma | ma.getQualifier() = this.asExpr() |
      ma.getMethod() instanceof ObjectMapperReadMethod
    )
  }
}

/** A source that sets a type validator. */
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

/**
 * Tracks flow from a remote source to a type descriptor (e.g. a `java.lang.Class` instance)
 * passed to a Jackson deserialization method.
 *
 * If this is user-controlled, arbitrary code could be executed while instantiating the user-specified type.
 */
class UnsafeTypeConfig extends TaintTracking2::Configuration {
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
 * Tracks flow from calls which set a type validator to a subsequent Jackson deserialization method call,
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

/** Holds if `fromNode` to `toNode` is a dataflow step that resolves a class. s */
private predicate resolveClassStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(ReflectiveClassIdentifierMethodAccess ma |
    ma.getArgument(0) = fromNode.asExpr() and
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
predicate hasArgumentWithUnsafeJacksonAnnotation(MethodAccess call) {
  call.getMethod() instanceof ObjectMapperReadMethod and
  exists(RefType argType, int i | i > 0 and argType = call.getArgument(i).getType() |
    hasJsonTypeInfoAnnotation(argType.(ParameterizedType).getATypeArgument())
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
