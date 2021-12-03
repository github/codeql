/** Provides classes related to the namespace `System.Security.Cryptography.X509Certificates`. */

import csharp
private import semmle.code.csharp.frameworks.system.security.Cryptography

/** The `System.Security.Cryptography.X509Certificates` namespace. */
class SystemSecurityCryptographyX509CertificatesNamespace extends Namespace {
  SystemSecurityCryptographyX509CertificatesNamespace() {
    this.getParentNamespace() instanceof SystemSecurityCryptographyNamespace and
    this.hasName("X509Certificates")
  }
}

/** A class in the `System.Security.Cryptography.X509Certificates` namespace. */
class SystemSecurityCryptographyX509CertificatesClass extends Class {
  SystemSecurityCryptographyX509CertificatesClass() {
    this.getNamespace() instanceof SystemSecurityCryptographyX509CertificatesNamespace
  }
}

/**
 * The `X509Certificate` or `X509Certificate2` class in the namespace
 * `System.Security.Cryptography.X509Certificates`.
 */
class SystemSecurityCryptographyX509CertificatesX509CertificateClass extends SystemSecurityCryptographyX509CertificatesClass {
  SystemSecurityCryptographyX509CertificatesX509CertificateClass() {
    this.hasName("X509Certificate") or
    this.hasName("X509Certificate2")
  }
}
