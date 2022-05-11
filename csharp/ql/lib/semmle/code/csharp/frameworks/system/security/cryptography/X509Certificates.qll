/** Provides classes related to the namespace `System.Security.Cryptography.X509Certificates`. */

import csharp
private import semmle.code.csharp.frameworks.system.security.Cryptography
private import semmle.code.csharp.dataflow.ExternalFlow

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

/** Data flow for `System.Security.Cryptography.X509Certificates.X509Certificate2Collection`. */
private class SystemSecurityCryptographyX509CertificatesX509Certificate2CollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Security.Cryptography.X509Certificates;X509Certificate2Collection;false;Add;(System.Security.Cryptography.X509Certificates.X509Certificate2);;Argument[0];Argument[Qualifier].Element;value",
        "System.Security.Cryptography.X509Certificates;X509Certificate2Collection;false;AddRange;(System.Security.Cryptography.X509Certificates.X509Certificate2Collection);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Security.Cryptography.X509Certificates;X509Certificate2Collection;false;AddRange;(System.Security.Cryptography.X509Certificates.X509Certificate2[]);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Security.Cryptography.X509Certificates;X509Certificate2Collection;false;Find;(System.Security.Cryptography.X509Certificates.X509FindType,System.Object,System.Boolean);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Security.Cryptography.X509Certificates;X509Certificate2Collection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Security.Cryptography.X509Certificates.X509Certificate2Enumerator.Current];value",
        "System.Security.Cryptography.X509Certificates;X509Certificate2Collection;false;Insert;(System.Int32,System.Security.Cryptography.X509Certificates.X509Certificate2);;Argument[1];Argument[Qualifier].Element;value",
        "System.Security.Cryptography.X509Certificates;X509Certificate2Collection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Security.Cryptography.X509Certificates;X509Certificate2Collection;false;set_Item;(System.Int32,System.Security.Cryptography.X509Certificates.X509Certificate2);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Security.Cryptography.X509Certificates.X509CertificateCollection`. */
private class SystemSecurityCryptographyX509CertificatesX509CertificateCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Security.Cryptography.X509Certificates;X509CertificateCollection;false;Add;(System.Security.Cryptography.X509Certificates.X509Certificate);;Argument[0];Argument[Qualifier].Element;value",
        "System.Security.Cryptography.X509Certificates;X509CertificateCollection;false;AddRange;(System.Security.Cryptography.X509Certificates.X509CertificateCollection);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Security.Cryptography.X509Certificates;X509CertificateCollection;false;AddRange;(System.Security.Cryptography.X509Certificates.X509Certificate[]);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Security.Cryptography.X509Certificates;X509CertificateCollection;false;CopyTo;(System.Security.Cryptography.X509Certificates.X509Certificate[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Security.Cryptography.X509Certificates;X509CertificateCollection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Security.Cryptography.X509Certificates.X509CertificateCollection+X509CertificateEnumerator.Current];value",
        "System.Security.Cryptography.X509Certificates;X509CertificateCollection;false;Insert;(System.Int32,System.Security.Cryptography.X509Certificates.X509Certificate);;Argument[1];Argument[Qualifier].Element;value",
        "System.Security.Cryptography.X509Certificates;X509CertificateCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Security.Cryptography.X509Certificates;X509CertificateCollection;false;set_Item;(System.Int32,System.Security.Cryptography.X509Certificates.X509Certificate);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Security.Cryptography.X509Certificates.X509ClainElementCollection`. */
private class SystemSecurityCryptographyX509CertificatesX509ClainElementCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Security.Cryptography.X509Certificates;X509ChainElementCollection;false;CopyTo;(System.Security.Cryptography.X509Certificates.X509ChainElement[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Security.Cryptography.X509Certificates;X509ChainElementCollection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Security.Cryptography.X509Certificates.X509ChainElementEnumerator.Current];value",
      ]
  }
}

/** Data flow for `System.Security.Cryptography.X509Certificates.X509ExtensionCollection`. */
private class SystemSecurityCryptographyX509CertificatesX509ExtensionCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Security.Cryptography.X509Certificates;X509ExtensionCollection;false;Add;(System.Security.Cryptography.X509Certificates.X509Extension);;Argument[0];Argument[Qualifier].Element;value",
        "System.Security.Cryptography.X509Certificates;X509ExtensionCollection;false;CopyTo;(System.Security.Cryptography.X509Certificates.X509Extension[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Security.Cryptography.X509Certificates;X509ExtensionCollection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Security.Cryptography.X509Certificates.X509ExtensionEnumerator.Current];value",
      ]
  }
}
