/**
 * @name Unsafe usage of v1 version of Azure Storage client-side encryption.
 * @description Using version v1 of Azure Storage client-side encryption is insecure, and may enable an attacker to decrypt encrypted data
 * @kind problem
 * @tags security
 *       cryptography
 *       external/cwe/cwe-327
 * @id py/azure-storage/unsafe-client-side-encryption-in-use
 * @problem.severity error
 * @precision medium
 */

import python

predicate isUnsafeClientSideAzureStorageEncryptionViaAttributes(Call call, AttrNode node) {
  exists(ControlFlowNode ctrlFlowNode, AssignStmt astmt, Attribute a |
    astmt.getATarget() = a and
    a.getAttr() in ["key_encryption_key", "key_resolver_function"] and
    a.getAFlowNode() = node and
    node.strictlyReaches(ctrlFlowNode) and
    node != ctrlFlowNode and
    call.getAChildNode().(Attribute).getAttr() = "upload_blob" and
    ctrlFlowNode = call.getAFlowNode() and
    not astmt.getValue() instanceof None and
    not exists(AssignStmt astmt2, Attribute a2, AttrNode encryptionVersionSet, StrConst uc |
      uc = astmt2.getValue() and
      uc.getText() in ["'2.0'", "2.0"] and
      a2.getAttr() = "encryption_version" and
      a2.getAFlowNode() = encryptionVersionSet and
      encryptionVersionSet.strictlyReaches(ctrlFlowNode)
    )
  )
}

predicate isUnsafeClientSideAzureStorageEncryptionViaObjectCreation(Call call, ControlFlowNode node) {
  exists(Keyword k | k.getAFlowNode() = node |
    call.getFunc().(Name).getId() in ["ContainerClient", "BlobClient", "BlobServiceClient"] and
    k.getArg() = "key_encryption_key" and
    k = call.getANamedArg() and
    not k.getValue() instanceof None and
    not exists(Keyword k2 | k2 = call.getANamedArg() |
      k2.getArg() = "encryption_version" and
      k2.getValue().(StrConst).getText() in ["'2.0'", "2.0"]
    )
  )
}

from Call call, ControlFlowNode node
where
  isUnsafeClientSideAzureStorageEncryptionViaAttributes(call, node) or
  isUnsafeClientSideAzureStorageEncryptionViaObjectCreation(call, node)
select node, "Unsafe usage of v1 version of Azure Storage client-side encryption."
