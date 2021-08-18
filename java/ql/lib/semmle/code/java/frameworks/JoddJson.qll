/**
 * Provides classes and predicates for working with the Jodd JSON framework.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

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

/**
 * A partial model of jodd.json.JsonParser noting fluent methods.
 *
 * This means that DataFlow::localFlow and similar methods are aware
 * that the result of (e.g.) JsonParser.allowClass is an alias of the
 * qualifier.
 */
private class JsonParserFluentMethods extends SummaryModelCsv {
  override predicate row(string s) {
    s =
      [
        "jodd.json;JsonParser;false;allowAllClasses;;;Argument[-1];ReturnValue;value",
        "jodd.json;JsonParser;false;allowClass;;;Argument[-1];ReturnValue;value",
        "jodd.json;JsonParser;false;lazy;;;Argument[-1];ReturnValue;value",
        "jodd.json;JsonParser;false;looseMode;;;Argument[-1];ReturnValue;value",
        "jodd.json;JsonParser;false;map;;;Argument[-1];ReturnValue;value",
        "jodd.json;JsonParser;false;setClassMetadataName;;;Argument[-1];ReturnValue;value",
        "jodd.json;JsonParser;false;strictTypes;;;Argument[-1];ReturnValue;value",
        "jodd.json;JsonParser;false;useAltPaths;;;Argument[-1];ReturnValue;value",
        "jodd.json;JsonParser;false;withClassMetadata;;;Argument[-1];ReturnValue;value",
        "jodd.json;JsonParser;false;withValueConverter;;;Argument[-1];ReturnValue;value"
      ]
  }
}
