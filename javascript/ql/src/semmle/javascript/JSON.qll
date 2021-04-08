/**
 * Provides classes for working with JSON data.
 */

import javascript

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
class JSONValue extends @json_value, Locatable {
  override Location getLocation() { json_locations(this, result) }

  /** Gets the parent value to which this value belongs, if any. */
  JSONValue getParent() { json(this, _, result, _, _) }

  /** Gets the `i`th child value of this value. */
  JSONValue getChild(int i) { json(result, _, this, i, _) }

  /** Holds if this JSON value is the top level element in its enclosing file. */
  predicate isTopLevel() { not exists(getParent()) }

  override string toString() { json(this, _, _, _, result) }

  /** Gets the JSON file containing this value. */
  File getJsonFile() {
    exists(Location loc |
      json_locations(this, loc) and
      result = loc.getFile()
    )
  }

  override string getAPrimaryQlClass() { result = "JSONValue" }
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
abstract class JSONPrimitiveValue extends JSONValue {
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
class JSONNull extends @json_null, JSONPrimitiveValue {
  override string getAPrimaryQlClass() { result = "JSONNull" }
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
class JSONBoolean extends @json_boolean, JSONPrimitiveValue {
  override string getAPrimaryQlClass() { result = "JSONBoolean" }
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
class JSONNumber extends @json_number, JSONPrimitiveValue {
  override string getAPrimaryQlClass() { result = "JSONNumber" }
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
class JSONString extends @json_string, JSONPrimitiveValue {
  override string getAPrimaryQlClass() { result = "JSONString" }
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
class JSONArray extends @json_array, JSONValue {
  /** Gets the value of the `i`th element of this array. */
  JSONValue getElementValue(int i) { result = getChild(i) }

  /** Gets the string value of the `i`th element of this array. */
  string getElementStringValue(int i) { result = getElementValue(i).(JSONString).getValue() }

  override string getAPrimaryQlClass() { result = "JSONArray" }
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
class JSONObject extends @json_object, JSONValue {
  /** Gets the value of property `name` of this object. */
  JSONValue getPropValue(string name) { json_properties(this, name, result) }

  /** Gets the string value of property `name` of this object. */
  string getPropStringValue(string name) { result = getPropValue(name).(JSONString).getValue() }

  override string getAPrimaryQlClass() { result = "JSONObject" }
}

/**
 * An error reported by the JSON parser.
 */
class JSONParseError extends @json_parse_error, Error {
  override Location getLocation() { json_locations(this, result) }

  override string getMessage() { json_errors(this, result) }
}
