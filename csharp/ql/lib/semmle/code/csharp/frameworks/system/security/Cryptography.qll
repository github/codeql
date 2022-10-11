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
        "System.Security.Cryptography;AsnEncodedDataCollection;false;Add;(System.Security.Cryptography.AsnEncodedData);;Argument[0];Argument[this].Element;value;manual",
        "System.Security.Cryptography;AsnEncodedDataCollection;false;CopyTo;(System.Security.Cryptography.AsnEncodedData[],System.Int32);;Argument[this].Element;Argument[0].Element;value;manual",
        "System.Security.Cryptography;AsnEncodedDataCollection;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Security.Cryptography.AsnEncodedDataEnumerator.Current];value;manual",
      ]
  }
}

/** Data flow for `System.Security.Cryptography.OidCollection`. */
private class SystemSecurityCryptographyOidCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Security.Cryptography;OidCollection;false;Add;(System.Security.Cryptography.Oid);;Argument[0];Argument[this].Element;value;manual",
        "System.Security.Cryptography;OidCollection;false;CopyTo;(System.Security.Cryptography.Oid[],System.Int32);;Argument[this].Element;Argument[0].Element;value;manual",
        "System.Security.Cryptography;OidCollection;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Security.Cryptography.OidEnumerator.Current];value;manual",
      ]
  }
}

/** Sinks for `System.Security.Cryptography`. */
private class SystemSecurityCryptographySinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Security.Cryptography;SymmetricAlgorithm;true;CreateEncryptor;(System.Byte[],System.Byte[]);;Argument[0];encryption-encryptor;manual",
        "System.Security.Cryptography;SymmetricAlgorithm;true;CreateDecryptor;(System.Byte[],System.Byte[]);;Argument[0];encryption-decryptor;manual",
        "System.Security.Cryptography;SymmetricAlgorithm;true;set_Key;(System.Byte[]);;Argument[0];encryption-keyprop;manual",
      ]
  }
}

/** Sinks for `Windows.Security.Cryptography.Core`. */
private class WindowsSecurityCryptographyCoreSinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      "Windows.Security.Cryptography.Core;SymmetricKeyAlgorithmProvider;false;CreateSymmetricKey;(Windows.Storage.Streams.IBuffer);;Argument[0];encryption-symmetrickey;manual"
  }
}
