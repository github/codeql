/**
 * Provides classes for working with JSON data.
 */

import javascript
private import semmle.javascript.internal.Locations

/**
 * A JSON-encoded value, which may be a primitive value, an array or an object.
 *
 * Examples:
 *
 * ```
 * null
 * true
 * false
 * 42
 * "a string"
 * [ 1, 2, 3 ]
 * { "value": 0 }
 * ```
 */
class JsonValue extends @json_value, Locatable {
  /** Gets the parent value to which this value belongs, if any. */
  JsonValue getParent() { json(this, _, result, _, _) }

  /** Gets the `i`th child value of this value. */
  JsonValue getChild(int i) { json(result, _, this, i, _) }

  /** Holds if this JSON value is the top level element in its enclosing file. */
  predicate isTopLevel() { not exists(this.getParent()) }

  override string toString() { json(this, _, _, _, result) }

  /** Gets the JSON file containing this value. */
  File getJsonFile() { result = getLocatableLocation(this).getFile() }

  /** If this is an object, gets the value of property `name`. */
  JsonValue getPropValue(string name) { json_properties(this, name, result) }

  /** If this is an array, gets the value of the `i`th element. */
  JsonValue getElementValue(int i) { result = this.(JsonArray).getChild(i) }

  /** If this is a string constant, gets the value of the string. */
  string getStringValue() { result = this.(JsonString).getValue() }

  /** If this is an integer constant, gets its numeric value. */
  int getIntValue() { result = this.(JsonNumber).getValue().toInt() }

  /** If this is a boolean constant, gets its boolean value. */
  boolean getBooleanValue() {
    result.toString() = this.(JsonBoolean).getValue() and result = [true, false]
  }

  override string getAPrimaryQlClass() { result = "JsonValue" }
}

/**
 * A JSON-encoded primitive value.
 *
 * Examples:
 *
 * ```
 * null
 * true
 * false
 * 42
 * "a string"
 * ```
 */
abstract class JsonPrimitiveValue extends JsonValue {
  /** Gets a string representation of the encoded value. */
  string getValue() { json_literals(result, _, this) }

  /** Gets the source text of the encoded value; for strings, this includes quotes. */
  string getRawValue() { json_literals(_, result, this) }
}

/**
 * A JSON-encoded null value.
 *
 * Example:
 *
 * ```
 * null
 * ```
 */
class JsonNull extends @json_null, JsonPrimitiveValue {
  override string getAPrimaryQlClass() { result = "JsonNull" }
}

/**
 * A JSON-encoded Boolean value.
 *
 * Examples:
 *
 * ```
 * true
 * false
 * ```
 */
class JsonBoolean extends @json_boolean, JsonPrimitiveValue {
  override string getAPrimaryQlClass() { result = "JsonBoolean" }
}

/**
 * A JSON-encoded number.
 *
 * Examples:
 *
 * ```
 * 42
 * 1.0
 * ```
 */
class JsonNumber extends @json_number, JsonPrimitiveValue {
  override string getAPrimaryQlClass() { result = "JsonNumber" }
}

/**
 * A JSON-encoded string value.
 *
 * Example:
 *
 * ```
 * "a string"
 * ```
 */
class JsonString extends @json_string, JsonPrimitiveValue {
  override string getAPrimaryQlClass() { result = "JsonString" }
}

/**
 * A JSON-encoded array.
 *
 * Example:
 *
 * ```
 * [ 1, 2, 3 ]
 * ```
 */
class JsonArray extends @json_array, JsonValue {
  override string getAPrimaryQlClass() { result = "JsonArray" }

  /** Gets the string value of the `i`th element of this array. */
  string getElementStringValue(int i) { result = this.getElementValue(i).getStringValue() }
}

/**
 * A JSON-encoded object.
 *
 * Example:
 *
 * ```
 * { "value": 0 }
 * ```
 */
class JsonObject extends @json_object, JsonValue {
  override string getAPrimaryQlClass() { result = "JsonObject" }

  /** Gets the string value of property `name` of this object. */
  string getPropStringValue(string name) { result = this.getPropValue(name).getStringValue() }
}

/**
 * An error reported by the JSON parser.
 */
class JsonParseError extends @json_parse_error, Error {
  override string getMessage() { json_errors(this, result) }
}
