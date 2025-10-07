/**
 * @name Unsafe usage of v1 version of Azure Storage client-side encryption (CVE-2022-30187).
 * @description Unsafe usage of v1 version of Azure Storage client-side encryption, please refer to http://aka.ms/azstorageclientencryptionblog
 * @kind problem
 * @tags security
 *       cryptography
 *       experimental
 *       external/cwe/cwe-327
 * @id cs/azure-storage/unsafe-usage-of-client-side-encryption-version
 * @problem.severity error
 * @precision high
 */

import csharp

/**
 * Holds if `oc` is creating an object of type `c` = `Azure.Storage.ClientSideEncryptionOptions`
 * and `e` is the `version` argument to the constructor
 */
predicate isCreatingAzureClientSideEncryptionObject(ObjectCreation oc, Class c, Expr e) {
  exists(Parameter p | p.hasName("version") |
    c.hasFullyQualifiedName("Azure.Storage", "ClientSideEncryptionOptions") and
    oc.getTarget() = c.getAConstructor() and
    e = oc.getArgumentForParameter(p)
  )
}

/**
 * Holds if `oc` is an object creation of the outdated type `c` = `Microsoft.Azure.Storage.Blob.BlobEncryptionPolicy`
 */
predicate isCreatingOutdatedAzureClientSideEncryptionObject(ObjectCreation oc, Class c) {
  c.hasFullyQualifiedName("Microsoft.Azure.Storage.Blob", "BlobEncryptionPolicy") and
  oc.getTarget() = c.getAConstructor()
}

/**
 * Holds if the Azure.Storage assembly for `c` is a version known to support
 * version 2+ for client-side encryption
 */
predicate doesAzureStorageAssemblySupportSafeClientSideEncryption(Assembly asm) {
  exists(int versionCompare |
    versionCompare = asm.getVersion().compareTo("12.12.0.0") and
    versionCompare >= 0
  ) and
  asm.getName() = "Azure.Storage.Common"
}

/**
 * Holds if the Azure.Storage assembly for `c` is a version known to support
 * version 2+ for client-side encryption and if the argument for the constructor `version`
 * is set to a secure value.
 */
predicate isObjectCreationArgumentSafeAndUsingSafeVersionOfAssembly(Expr versionExpr, Assembly asm) {
  // Check if the Azure.Storage assembly version has the fix
  doesAzureStorageAssemblySupportSafeClientSideEncryption(asm) and
  // and that the version argument for the constructor is guaranteed to be Version2
  isExprAnAccessToSafeClientSideEncryptionVersionValue(versionExpr)
}

/**
 * Holds if the expression `e` is an access to a safe version of the enum `ClientSideEncryptionVersion`
 * or an equivalent numeric value
 */
predicate isExprAnAccessToSafeClientSideEncryptionVersionValue(Expr e) {
  exists(EnumConstant ec |
    ec.hasFullyQualifiedName("Azure.Storage.ClientSideEncryptionVersion", "V2_0") and
    ec.getAnAccess() = e
  )
}

deprecated query predicate problems(Expr e, string message) {
  exists(Class c, Assembly asm | asm = c.getLocation() |
    exists(Expr e2 |
      isCreatingAzureClientSideEncryptionObject(e, c, e2) and
      not isObjectCreationArgumentSafeAndUsingSafeVersionOfAssembly(e2, asm)
    )
    or
    isCreatingOutdatedAzureClientSideEncryptionObject(e, c)
  ) and
  message = "Unsafe usage of v1 version of Azure Storage client-side encryption."
}
