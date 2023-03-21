/** Provides classes related to the namespace `System.Security.Cryptography`. */

import csharp
private import semmle.code.csharp.frameworks.system.Security

/** The `System.Security.Cryptography` namespace. */
class SystemSecurityCryptographyNamespace extends Namespace {
  SystemSecurityCryptographyNamespace() {
    this.getParentNamespace() instanceof SystemSecurityNamespace and
    this.hasName("Cryptography")
  }
}

/** A class in the `System.Security.Cryptography` namespace. */
class SystemSecurityCryptographyClass extends Class {
  SystemSecurityCryptographyClass() {
    this.getNamespace() instanceof SystemSecurityCryptographyNamespace
  }
}
