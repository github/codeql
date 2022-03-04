/* Definitions related to `java.util.Properties`. */
import semmle.code.java.Type
private import semmle.code.java.dataflow.FlowSteps

class TypeProperty extends Class {
  TypeProperty() { hasQualifiedName("java.util", "Properties") }
}

class PropertiesGetPropertyMethod extends ValuePreservingMethod {
  PropertiesGetPropertyMethod() {
    getDeclaringType() instanceof TypeProperty and
    hasName("getProperty")
  }

  override predicate returnsValue(int arg) { arg = 1 }
}

class PropertiesGetMethod extends Method {
  PropertiesGetMethod() {
    getDeclaringType() instanceof TypeProperty and
    hasName("get")
  }
}

class PropertiesSetPropertyMethod extends Method {
  PropertiesSetPropertyMethod() {
    getDeclaringType() instanceof TypeProperty and
    hasName("setProperty")
  }
}

class PropertiesStoreMethod extends Method {
  PropertiesStoreMethod() {
    getDeclaringType() instanceof TypeProperty and
    (getName().matches("store%") or getName() = "save")
  }
}
