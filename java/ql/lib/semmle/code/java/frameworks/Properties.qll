/** Definitions related to `java.util.Properties`. */

import semmle.code.java.Type
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.configfiles.ConfigFiles
private import semmle.code.java.dataflow.RangeUtils

/**
 * The `java.util.Properties` class.
 */
class TypeProperty extends Class {
  TypeProperty() { this.hasQualifiedName("java.util", "Properties") }
}

/** The `getProperty` method of the class `java.util.Properties`. */
class PropertiesGetPropertyMethod extends Method {
  PropertiesGetPropertyMethod() {
    this.getDeclaringType() instanceof TypeProperty and
    this.hasName("getProperty")
  }
}

/** The `get` method of the class `java.util.Properties`. */
class PropertiesGetMethod extends Method {
  PropertiesGetMethod() {
    this.getDeclaringType() instanceof TypeProperty and
    this.hasName("get")
  }
}

/** The `setProperty` method of the class `java.util.Properties`. */
class PropertiesSetPropertyMethod extends Method {
  PropertiesSetPropertyMethod() {
    this.getDeclaringType() instanceof TypeProperty and
    this.hasName("setProperty")
  }
}

/**
 * The methods of the class `java.util.Properties` that write the contents to an output.
 */
class PropertiesStoreMethod extends Method {
  PropertiesStoreMethod() {
    this.getDeclaringType() instanceof TypeProperty and
    (this.getName().matches("store%") or this.getName() = "save")
  }
}

/**
 * A call to the `getProperty` method of the class `java.util.Properties`.
 */
class PropertiesGetPropertyMethodCall extends MethodCall {
  PropertiesGetPropertyMethodCall() { this.getMethod() instanceof PropertiesGetPropertyMethod }

  private ConfigPair getPair() {
    this.getArgument(0).(ConstantStringExpr).getStringValue() = result.getNameElement().getName()
  }

  /**
   * Get the potential string values that can be associated with the given property name.
   */
  string getPropertyValue() {
    result = this.getPair().getValueElement().getValue() or
    result = this.getArgument(1).(ConstantStringExpr).getStringValue()
  }
}
