/**
 * Provides classes and predicates for working with configuration files, such
 * as Java .properties or .ini files.
 */

import semmle.code.Location

/** Each element in a configuration file has a location. */
abstract class ConfigLocatable extends @configLocatable {
  /** Retrieve the source location for this element. */
  Location getLocation() {
    configLocations(this, result)
  }

  /** The file associated with this element. */
  File getFile() {
    result = getLocation().getFile()
  }

  /** Gets a textual representation of this element. */
  abstract string toString();
}

/**
 * A name-value pair often used to store configuration properties
 * for applications, such as the port, name or address of a database.
 */
class ConfigPair extends @config, ConfigLocatable {

  /** If this ConfigPair has a name element, return it. */
  ConfigName getNameElement() {
    configNames(result, this, _)
  }

  /** If this ConfigPair has a value element, return it. */
  ConfigValue getValueElement() {
    configValues(result, this, _)
  }

  /**
   * If this ConfigPair has a name element, return its string value.
   * Otherwise return the empty string.
   */
  string getEffectiveName() {
    if exists(getNameElement()) then
      result = getNameElement().getName()
    else
      result = ""
  }

  /**
   * If this ConfigPair has a value element, return its string value.
   * Otherwise return the empty string.
   */
  string getEffectiveValue() {
    if exists(getValueElement()) then
      result = getValueElement().getValue()
    else
      result = ""
  }

  /** A printable representation of this ConfigPair. */
  override string toString() {
    result = getEffectiveName() + "=" + getEffectiveValue()
  }
}

/** The name element of a ConfigPair. */
class ConfigName extends @configName, ConfigLocatable {

  /** Returns the name as a string. */
  string getName() {
    configNames(this, _, result)
  }

  /** A printable representation of this ConfigName. */
  override string toString() {
    result = getName()
  }
}

/** The value element of a ConfigPair. */
class ConfigValue extends @configValue, ConfigLocatable {

  /** Returns the value as a string. */
  string getValue() {
    configValues(this, _, result)
  }

  /** A printable representation of this ConfigValue. */
  override string toString() {
    result = getValue()
  }
}

/** A Java property is a name-value pair in a .properties file. */
class JavaProperty extends ConfigPair {
  JavaProperty() {
    getFile().getExtension() = "properties"
  }
}
