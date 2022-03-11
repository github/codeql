/* Definitions related to `java.util.Properties`. */
import semmle.code.java.Type
private import semmle.code.java.dataflow.FlowSteps

/**
 * The `java.util.Properties` class.
 */
class TypeProperty extends Class {
  TypeProperty() { hasQualifiedName("java.util", "Properties") }
}

/** The `getProperty` method of the class `java.util.Properties`. */
class PropertiesGetPropertyMethod extends ValuePreservingMethod {
  PropertiesGetPropertyMethod() {
    getDeclaringType() instanceof TypeProperty and
    hasName("getProperty")
  }

  override predicate returnsValue(int arg) { arg = 1 }
}

/** The `get` method of the class `java.util.Properties`. */
class PropertiesGetMethod extends Method {
  PropertiesGetMethod() {
    getDeclaringType() instanceof TypeProperty and
    hasName("get")
  }
}

/** The `setProperty` method of the class `java.util.Properties`. */
class PropertiesSetPropertyMethod extends Method {
  PropertiesSetPropertyMethod() {
    getDeclaringType() instanceof TypeProperty and
    hasName("setProperty")
  }
}

/**
 * The methods of the class `java.util.Properties` that write the contents to an output.
 */
class PropertiesStoreMethod extends Method {
  PropertiesStoreMethod() {
    getDeclaringType() instanceof TypeProperty and
    (getName().matches("store%") or getName() = "save")
  }
}
