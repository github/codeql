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
class JsonValue extends @json_value, Locatable {
  override Location getLocation() { json_locations(this, result) }

  /** Gets the parent value to which this value belongs, if any. */
  JsonValue getParent() { json(this, _, result, _, _) }

  /** Gets the `i`th child value of this value. */
  JsonValue getChild(int i) { json(result, _, this, i, _) }

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

  /** If this is an object, gets the value of property `name`. */
  JsonValue getPropValue(string name) { json_properties(this, name, result) }

  /** If this is an array, gets the value of the `i`th element. */
  JsonValue getElementValue(int i) { result = this.(JsonArray).getChild(i) }

  /** If this is a string constant, gets the value of the string. */
  string getStringValue() { result = this.(JsonString).getValue() }

  /** If this is an integer constant, gets its numeric value. */
  int getIntValue() { result = this.(JsonNumber).getValue().toInt() }

  /** If this is a boolean constant, gets its boolean value. */
  boolean getBooleanValue() { result.toString() = this.(JsonBoolean).getValue() }

  override string getAPrimaryQlClass() { result = "JsonValue" }
}

/** DEPRECATED: Alias for JsonValue */
deprecated class JSONValue = JsonValue;

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

/** DEPRECATED: Alias for JsonPrimitiveValue */
deprecated class JSONPrimitiveValue = JsonPrimitiveValue;

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

/** DEPRECATED: Alias for JsonNull */
deprecated class JSONNull = JsonNull;

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

/** DEPRECATED: Alias for JsonBoolean */
deprecated class JSONBoolean = JsonBoolean;

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

/** DEPRECATED: Alias for JsonNumber */
deprecated class JSONNumber = JsonNumber;

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

/** DEPRECATED: Alias for JsonString */
deprecated class JSONString = JsonString;

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
  string getElementStringValue(int i) { result = getElementValue(i).getStringValue() }
}

/** DEPRECATED: Alias for JsonArray */
deprecated class JSONArray = JsonArray;

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
  string getPropStringValue(string name) { result = getPropValue(name).getStringValue() }
}

/** DEPRECATED: Alias for JsonObject */
deprecated class JSONObject = JsonObject;

/**
 * An error reported by the JSON parser.
 */
class JsonParseError extends @json_parse_error, Error {
  override Location getLocation() { json_locations(this, result) }

  override string getMessage() { json_errors(this, result) }
}

/** DEPRECATED: Alias for JsonParseError */
deprecated class JSONParseError = JsonParseError;
