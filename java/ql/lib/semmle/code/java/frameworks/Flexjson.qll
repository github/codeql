/**
 * Provides classes for working with the Flexjson framework.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

/** The class `flexjson.JSONDeserializer`. */
class FlexjsonDeserializer extends RefType {
  FlexjsonDeserializer() { this.hasQualifiedName("flexjson", "JSONDeserializer") }
}

/** The class `flexjson.ObjectFactory`. */
class FlexjsonObjectFactory extends RefType {
  FlexjsonObjectFactory() { this.hasQualifiedName("flexjson", "ObjectFactory") }
}

/** The deserialization method `deserialize`. */
class FlexjsonDeserializeMethod extends Method {
  FlexjsonDeserializeMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof
      FlexjsonDeserializer and
    this.getName() = "deserialize" and
    not this.getAParameter().getType() instanceof FlexjsonObjectFactory // deserialization method with specified class types in object factory is unlikely to be vulnerable
  }
}

/** The method `use` to configure allowed class type. */
class FlexjsonDeserializerUseMethod extends Method {
  FlexjsonDeserializerUseMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof
      FlexjsonDeserializer and
    this.hasName("use")
  }
}

private class FluentUseMethodModel extends SummaryModelCsv {
  override predicate row(string r) {
    r = "flexjson;JSONDeserializer;true;use;;;Argument[-1];ReturnValue;value"
  }
}
