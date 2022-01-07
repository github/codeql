/** Provides classes related to the namespace `System.Security`. */

import csharp
private import semmle.code.csharp.frameworks.System

/** The `System.Security` namespace. */
class SystemSecurityNamespace extends Namespace {
  SystemSecurityNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Security")
  }
}

/** A class in the `System.Security` namespace. */
class SystemSecurityClass extends Class {
  SystemSecurityClass() { this.getNamespace() instanceof SystemSecurityNamespace }
}
