/** Provides definitions related to the namespace `System.Web.Services`. */
import csharp
private import semmle.code.csharp.frameworks.system.Web

/** The `System.Web.Services` namespace. */
class SystemWebServicesNamespace extends Namespace {
  SystemWebServicesNamespace() {
    this.getParentNamespace() instanceof SystemWebNamespace and
    this.hasName("Services")
  }
}

/** DEPRECATED. Gets the `System.Web.Services` namespace. */
deprecated
SystemWebServicesNamespace getSystemWebServicesNamespace() { any() }

/** A class in the `System.Web.Services` namespace. */
class SystemWebServicesClass extends Class {
  SystemWebServicesClass() {
    this.getNamespace() instanceof SystemWebServicesNamespace
  }
}

/** The `System.Web.Services.WebMethodAttribute` class. */
class SystemWebServicesWebMethodAttributeClass extends SystemWebServicesClass {
  SystemWebServicesWebMethodAttributeClass() {
    this.hasName("WebMethodAttribute")
  }
}

/** DEPRECATED. Gets the `System.Web.Services.WebMethodAttribute` class. */
deprecated
SystemWebServicesWebMethodAttributeClass getSystemWebServicesWebMethodAttributeClass() { any() }
