/**
 * @name Unsafe usage of v1 version of Azure Storage client-side encryption.
 * @description Using version v1 of Azure Storage client-side encryption is insecure, and may enable an attacker to decrypt encrypted data
 * @kind problem
 * @tags security
 *       experimental
 *       cryptography
 *       external/cwe/cwe-327
 * @id py/azure-storage/unsafe-client-side-encryption-in-use
 * @problem.severity error
 * @precision medium
 */

import python
import semmle.python.ApiGraphs

predicate isUnsafeClientSideAzureStorageEncryptionViaAttributes(Call call, AttrNode node) {
  exists(
    API::Node n, API::Node n2, Attribute a, AssignStmt astmt, API::Node uploadBlob,
    ControlFlowNode ctrlFlowNode, string s
  |
    s in ["key_encryption_key", "key_resolver_function"] and
    n =
      API::moduleImport("azure")
          .getMember("storage")
          .getMember("blob")
          .getMember("BlobClient")
          .getReturn()
          .getMember(s) and
    n2 =
      API::moduleImport("azure")
          .getMember("storage")
          .getMember("blob")
          .getMember("BlobClient")
          .getReturn()
          .getMember("upload_blob") and
    n.getAValueReachableFromSource().asExpr() = a and
    astmt.getATarget() = a and
    a.getAFlowNode() = node and
    uploadBlob =
      API::moduleImport("azure")
          .getMember("storage")
          .getMember("blob")
          .getMember("BlobClient")
          .getReturn()
          .getMember("upload_blob") and
    uploadBlob.getACall().asExpr() = call and
    ctrlFlowNode = call.getAFlowNode() and
    node.strictlyReaches(ctrlFlowNode) and
    node != ctrlFlowNode and
    not exists(
      AssignStmt astmt2, Attribute a2, AttrNode encryptionVersionSet, StrConst uc,
      API::Node encryptionVersion
    |
      uc = astmt2.getValue() and
      uc.getText() in ["'2.0'", "2.0"] and
      encryptionVersion =
        API::moduleImport("azure")
            .getMember("storage")
            .getMember("blob")
            .getMember("BlobClient")
            .getReturn()
            .getMember("encryption_version") and
      encryptionVersion.getAValueReachableFromSource().asExpr() = a2 and
      astmt2.getATarget() = a2 and
      a2.getAFlowNode() = encryptionVersionSet and
      encryptionVersionSet.strictlyReaches(ctrlFlowNode)
    )
  )
}

predicate isUnsafeClientSideAzureStorageEncryptionViaObjectCreation(Call call, ControlFlowNode node) {
  exists(API::Node c, string s, Keyword k | k.getAFlowNode() = node |
    c.getACall().asExpr() = call and
    c = API::moduleImport("azure").getMember("storage").getMember("blob").getMember(s) and
    s in ["ContainerClient", "BlobClient", "BlobServiceClient"] and
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
