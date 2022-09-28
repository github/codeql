/**
 * @name Unsafe usage of v1 version of Azure Storage client-side encryption (CVE-2022-30187).
 * @description Unsafe usage of v1 version of Azure Storage client-side encryption, please refer to http://aka.ms/azstorageclientencryptionblog
 * @kind problem
 * @tags security
 *       cryptography
 *       external/cwe/cwe-327
 * @id java/azure-storage/unsafe-client-side-encryption-in-use
 * @problem.severity error
 * @precision high
 */

import java
import semmle.code.java.dataflow.DataFlow

/**
 * Holds if `call` is an object creation for a class `EncryptedBlobClientBuilder`
 * that takes no arguments, which means that it is using V1 encryption.
 */
predicate isCreatingOutdatedAzureClientSideEncryptionObject(Call call, Class c) {
  exists(string package, string type, Constructor constructor |
    c.hasQualifiedName(package, type) and
    c.getAConstructor() = constructor and
    call.getCallee() = constructor and
    (
      type = "EncryptedBlobClientBuilder" and
      package = "com.azure.storage.blob.specialized.cryptography" and
      constructor.hasNoParameters()
      or
      type = "BlobEncryptionPolicy" and package = "com.microsoft.azure.storage.blob"
    )
  )
}

/**
 * Holds if `call` is an object creation for a class `EncryptedBlobClientBuilder`
 * that takes `versionArg` as the argument specifying the encryption version.
 */
predicate isCreatingAzureClientSideEncryptionObjectNewVersion(Call call, Class c, Expr versionArg) {
  exists(string package, string type, Constructor constructor |
    c.hasQualifiedName(package, type) and
    c.getAConstructor() = constructor and
    call.getCallee() = constructor and
    type = "EncryptedBlobClientBuilder" and
    package = "com.azure.storage.blob.specialized.cryptography" and
    versionArg = call.getArgument(0)
  )
}

/**
 * A dataflow config that tracks `EncryptedBlobClientBuilder.version` argument initialization.
 */
private class EncryptedBlobClientBuilderSafeEncryptionVersionConfig extends DataFlow::Configuration {
  EncryptedBlobClientBuilderSafeEncryptionVersionConfig() {
    this = "EncryptedBlobClientBuilderSafeEncryptionVersionConfig"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(FieldRead fr, Field f | fr = source.asExpr() |
      f.getAnAccess() = fr and
      f.hasQualifiedName("com.azure.storage.blob.specialized.cryptography", "EncryptionVersion",
        "V2")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    isCreatingAzureClientSideEncryptionObjectNewVersion(_, _, sink.asExpr())
  }
}

/**
 * Holds if `call` is an object creation for a class `EncryptedBlobClientBuilder`
 * that takes `versionArg` as the argument specifying the encryption version, and that version is safe.
 */
predicate isCreatingSafeAzureClientSideEncryptionObject(Call call, Class c, Expr versionArg) {
  isCreatingAzureClientSideEncryptionObjectNewVersion(call, c, versionArg) and
  exists(EncryptedBlobClientBuilderSafeEncryptionVersionConfig config, DataFlow::Node sink |
    sink.asExpr() = versionArg
  |
    config.hasFlow(_, sink)
  )
}

from Expr e, Class c
where
  exists(Expr argVersion |
    isCreatingAzureClientSideEncryptionObjectNewVersion(e, c, argVersion) and
    not isCreatingSafeAzureClientSideEncryptionObject(e, c, argVersion)
  )
  or
  isCreatingOutdatedAzureClientSideEncryptionObject(e, c)
select e, "Unsafe usage of v1 version of Azure Storage client-side encryption."
