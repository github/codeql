/**
 * Provides classes and predicates for working with the JoddJson framework.
 */

import java

/** The class `jodd.json.Parser`. */
class JoddJsonParser extends RefType {
  JoddJsonParser() { this.hasQualifiedName("jodd.json", "JsonParser") }
}

/** The class `jodd.json.JsonSerializer`. */
class JoddJsonSerializer extends RefType {
  JoddJsonSerializer() { this.hasQualifiedName("jodd.json", "JsonSerializer") }
}

/** The `parse*` deserialization method. */
class JoddJsonParseMethod extends Method {
  JoddJsonParseMethod() {
    this.getDeclaringType() instanceof JoddJsonParser and
    this.getName().matches("parse%")
  }
}

/** The serialization method `serialize`. */
class JoddJsonSerializeMethod extends Method {
  JoddJsonSerializeMethod() {
    this.getDeclaringType() instanceof JoddJsonSerializer and
    this.hasName("serialize")
  }
}

/** The `setClassMetadataName` method. */
class SetClassMetadataNameMethod extends Method {
  SetClassMetadataNameMethod() {
    this.getDeclaringType() instanceof JoddJsonParser and
    this.hasName("setClassMetadataName")
  }
}

/** A call to `parser.withClassMetadata` method. */
class WithClassMetadata extends MethodAccess {
  WithClassMetadata() {
    this.getMethod().getDeclaringType() instanceof JoddJsonParser and
    this.getMethod().hasName("withClassMetadata")
  }

  /** Gets the constant value passed to this call. */
  boolean getMode() { result = this.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() }
}

/**
 * Holds if there is a call to `parser.withClassMetadata` that explicitly enables
 * class metadata.
 */
predicate enablesClassMetadata(WithClassMetadata wcm) { wcm.getMode() = true }

/** A call to `parser.allowClass` method. */
class SetWhitelistClasses extends MethodAccess {
  SetWhitelistClasses() {
    this.getMethod().getDeclaringType() instanceof JoddJsonParser and
    this.getMethod().hasName("allowClass")
  }

  /** Gets the configured value. */
  Expr getValue() { result = this.getArgument(0) }
}
