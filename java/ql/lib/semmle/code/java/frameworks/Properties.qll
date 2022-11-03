/* Definitions related to `java.util.Properties`. */
import semmle.code.java.Type

library class TypeProperty extends Class {
  TypeProperty() { hasQualifiedName("java.util", "Properties") }
}

library class PropertiesGetPropertyMethod extends Method {
  PropertiesGetPropertyMethod() {
    getDeclaringType() instanceof TypeProperty and
    hasName("getProperty")
  }
}

library class PropertiesSetPropertyMethod extends Method {
  PropertiesSetPropertyMethod() {
    getDeclaringType() instanceof TypeProperty and
    hasName("setProperty")
  }
}

library class PropertiesStoreMethod extends Method {
  PropertiesStoreMethod() {
    getDeclaringType() instanceof TypeProperty and
    (getName().matches("store%") or getName() = "save")
  }
}
