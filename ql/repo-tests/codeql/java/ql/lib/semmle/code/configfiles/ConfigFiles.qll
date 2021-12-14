/**
 * Provides classes and predicates for working with configuration files, such
 * as Java `.properties` or `.ini` files.
 */

import semmle.code.Location

/** An element in a configuration file has a location. */
abstract class ConfigLocatable extends @configLocatable {
  /** Gets the source location for this element. */
  Location getLocation() { configLocations(this, result) }

  /** Gets the file associated with this element. */
  File getFile() { result = getLocation().getFile() }

  /** Gets a textual representation of this element. */
  abstract string toString();
}

/**
 * A name-value pair often used to store configuration properties
 * for applications, such as the port, name or address of a database.
 */
class ConfigPair extends @config, ConfigLocatable {
  /** Gets the name of this `ConfigPair`, if any. */
  ConfigName getNameElement() { configNames(result, this, _) }

  /** Gets the value of this `ConfigPair`, if any. */
  ConfigValue getValueElement() { configValues(result, this, _) }

  /**
   * Gets the string value of the name of this `ConfigPair` if
   * it exists and the empty string if it doesn't.
   */
  string getEffectiveName() {
    if exists(getNameElement()) then result = getNameElement().getName() else result = ""
  }

  /**
   * Gets the string value of the value of this `ConfigPair` if
   * it exists and the empty string if it doesn't.
   */
  string getEffectiveValue() {
    if exists(getValueElement()) then result = getValueElement().getValue() else result = ""
  }

  /** Gets a printable representation of this `ConfigPair`. */
  override string toString() { result = getEffectiveName() + "=" + getEffectiveValue() }
}

/** The name element of a `ConfigPair`. */
class ConfigName extends @configName, ConfigLocatable {
  /** Gets the name as a string. */
  string getName() { configNames(this, _, result) }

  /** Gets a printable representation of this `ConfigName`. */
  override string toString() { result = getName() }
}

/** The value element of a `ConfigPair`. */
class ConfigValue extends @configValue, ConfigLocatable {
  /** Gets the value as a string. */
  string getValue() { configValues(this, _, result) }

  /** Gets a printable representation of this `ConfigValue`. */
  override string toString() { result = getValue() }
}

/** A Java property is a name-value pair in a `.properties` file. */
class JavaProperty extends ConfigPair {
  JavaProperty() { getFile().getExtension() = "properties" }
}
