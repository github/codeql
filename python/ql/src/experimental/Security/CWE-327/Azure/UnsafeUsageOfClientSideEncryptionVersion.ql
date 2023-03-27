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
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

predicate isUnsafeClientSideAzureStorageEncryptionViaAttributes(Call call, AttrNode node) {
  exists(
    API::Node client, DataFlow::AttrWrite keyAttrWrite, DataFlow::MethodCallNode uploadBlobCall
  |
    call = uploadBlobCall.asExpr() and node = keyAttrWrite.asCfgNode()
  |
    client =
      API::moduleImport("azure")
          .getMember("storage")
          .getMember("blob")
          .getMember(["ContainerClient", "BlobClient", "BlobServiceClient"])
          .getAMember()
          .getReturn() and
    keyAttrWrite
        .accesses(client.getAValueReachableFromSource(),
          ["key_encryption_key", "key_resolver_function"]) and
    uploadBlobCall.calls(client.getAValueReachableFromSource(), "upload_blob") and
    DataFlow::localFlow(keyAttrWrite.getObject(), uploadBlobCall.getObject()) and
    not exists(DataFlow::AttrWrite encryptionVersionWrite |
      encryptionVersionWrite.accesses(client.getAValueReachableFromSource(), "encryption_version") and
      encryptionVersionWrite.getValue().asExpr().(StrConst).getText() in ["'2.0'", "2.0"] and
      DataFlow::localFlow(keyAttrWrite.getObject(), encryptionVersionWrite.getObject()) and
      DataFlow::localFlow(encryptionVersionWrite.getObject(), uploadBlobCall.getObject())
    )
  )
}

from Call call, ControlFlowNode node
where isUnsafeClientSideAzureStorageEncryptionViaAttributes(call, node)
select node, "Unsafe usage of v1 version of Azure Storage client-side encryption."
