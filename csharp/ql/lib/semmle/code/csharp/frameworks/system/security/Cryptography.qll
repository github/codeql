/** Provides classes related to the namespace `System.Security.Cryptography`. */

import csharp
private import semmle.code.csharp.frameworks.system.Security
private import semmle.code.csharp.dataflow.ExternalFlow

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

/** Data flow for `System.Security.Cryptography.AsnEncodedDataCollection`. */
private class SystemSecurityCryptographyAsnEncondedDataCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Security.Cryptography;AsnEncodedDataCollection;false;Add;(System.Security.Cryptography.AsnEncodedData);;Argument[0];Element of Argument[Qualifier];value",
        "System.Security.Cryptography;AsnEncodedDataCollection;false;CopyTo;(System.Security.Cryptography.AsnEncodedData[],System.Int32);;Element of Argument[Qualifier];Element of Argument[0];value",
        "System.Security.Cryptography;AsnEncodedDataCollection;false;GetEnumerator;();;Element of Argument[Qualifier];Property[System.Security.Cryptography.AsnEncodedDataEnumerator.Current] of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Security.Cryptography.OidCollection`. */
private class SystemSecurityCryptographyOidCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Security.Cryptography;OidCollection;false;Add;(System.Security.Cryptography.Oid);;Argument[0];Element of Argument[Qualifier];value",
        "System.Security.Cryptography;OidCollection;false;CopyTo;(System.Security.Cryptography.Oid[],System.Int32);;Element of Argument[Qualifier];Element of Argument[0];value",
        "System.Security.Cryptography;OidCollection;false;GetEnumerator;();;Element of Argument[Qualifier];Property[System.Security.Cryptography.OidEnumerator.Current] of ReturnValue;value",
      ]
  }
}
