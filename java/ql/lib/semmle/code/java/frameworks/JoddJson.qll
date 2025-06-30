/**
 * Provides classes and predicates for working with the Jodd JSON framework.
 */
overlay[local?]
module;

import java

/** The class `jodd.json.Parser`. */
class JoddJsonParser extends RefType {
  JoddJsonParser() { this.hasQualifiedName("jodd.json", "JsonParser") }
}

/** A `JsonParser.parse*` deserialization method. */
class JoddJsonParseMethod extends Method {
  JoddJsonParseMethod() {
    this.getDeclaringType() instanceof JoddJsonParser and
    this.getName().matches("parse%")
  }
}

/** The `JsonParser.setClassMetadataName` method. */
class SetClassMetadataNameMethod extends Method {
  SetClassMetadataNameMethod() {
    this.getDeclaringType() instanceof JoddJsonParser and
    this.hasName("setClassMetadataName")
  }
}

/** The `JsonParser.withClassMetadata` method. */
class WithClassMetadataMethod extends Method {
  WithClassMetadataMethod() {
    this.getDeclaringType() instanceof JoddJsonParser and
    this.hasName("withClassMetadata")
  }
}

/** The `JsonParser.allowClass` method. */
class AllowClassMethod extends Method {
  AllowClassMethod() {
    this.getDeclaringType() instanceof JoddJsonParser and
    this.hasName("allowClass")
  }
}
