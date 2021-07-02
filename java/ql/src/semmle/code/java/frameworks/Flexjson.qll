/**
 * Provides classes for working with the Flexjson framework.
 */

import java

/** The class `flexjson.JSONDeserializer`. */
class FlexjsonDeserializer extends RefType {
  FlexjsonDeserializer() { this.hasQualifiedName("flexjson", "JSONDeserializer") }
}

/** The class `flexjson.JSONSerializer`. */
class FlexjsonSerializer extends RefType {
  FlexjsonSerializer() { this.hasQualifiedName("flexjson", "JSONSerializer") }
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

/** The serialization method `serialize`. */
class FlexjsonSerializeMethod extends Method {
  FlexjsonSerializeMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof
      FlexjsonSerializer and
    this.hasName(["serialize", "deepSerialize"])
  }
}

/** The method `use` to configure allowed class type. */
class DeserializerUseMethod extends Method {
  DeserializerUseMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof
      FlexjsonDeserializer and
    this.hasName("use")
  }
}
