/** Definitions related to the Apache Commons Lang library. */
overlay[local?]
module;

import java
private import semmle.code.java.dataflow.FlowSteps

/**
 * The class `org.apache.commons.lang.RandomStringUtils` or `org.apache.commons.lang3.RandomStringUtils`.
 */
class TypeApacheRandomStringUtils extends Class {
  TypeApacheRandomStringUtils() {
    this.hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"],
      "RandomStringUtils")
  }
}

/**
 * The method `deserialize` in either `org.apache.commons.lang.SerializationUtils`
 * or `org.apache.commons.lang3.SerializationUtils`.
 */
class MethodApacheSerializationUtilsDeserialize extends Method {
  MethodApacheSerializationUtilsDeserialize() {
    this.getDeclaringType()
        .hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"],
          "SerializationUtils") and
    this.hasName("deserialize")
  }
}

/**
 * An Apache Commons-Lang StrBuilder method that returns `this`.
 */
private class ApacheStrBuilderFluentMethod extends FluentMethod {
  ApacheStrBuilderFluentMethod() {
    this.getReturnType().(RefType).hasQualifiedName("org.apache.commons.lang3.text", "StrBuilder")
  }
}

/**
 * The class `org.apache.commons.lang.SystemUtils` or `org.apache.commons.lang3.SystemUtils`.
 */
class TypeApacheSystemUtils extends Class {
  TypeApacheSystemUtils() {
    this.hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"], "SystemUtils")
  }
}
