/** Definitions related to `java.util.Properties`. */

import semmle.code.java.Type
private import semmle.code.java.dataflow.FlowSteps

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
