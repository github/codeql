/** Provides definitions related to the namespace `System.Web.Helpers`. */

import csharp
import semmle.code.csharp.frameworks.system.Web

/** The `System.Web.Helpers` namespace. */
class SystemWebHelpersNamespace extends Namespace {
  SystemWebHelpersNamespace() { this.hasName("Helpers") }
}

/** The `System.Web.Helpers.AntiForgery` class. */
class AntiForgeryClass extends Class {
  AntiForgeryClass() {
    this.getNamespace() = any(SystemWebHelpersNamespace h) and
    this.hasName("AntiForgery")
  }

  /** Gets the `Validate` method. */
  Method getValidateMethod() { result = this.getAMethod("Validate") }
}
