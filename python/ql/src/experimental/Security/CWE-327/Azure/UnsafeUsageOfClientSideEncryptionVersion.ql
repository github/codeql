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
    API::Node n, ControlFlowNode startingNode, Attribute attr, ControlFlowNode ctrlFlowNode,
    Attribute attrUploadBlob, ControlFlowNode ctrlFlowNodeUploadBlob, string s1, string s2,
    string s3
  |
    call.getAChildNode() = attrUploadBlob and
    node = ctrlFlowNode
  |
    s1 in ["key_encryption_key", "key_resolver_function"] and
    s2 in ["ContainerClient", "BlobClient", "BlobServiceClient"] and
    s3 = "upload_blob" and
    n = API::moduleImport("azure").getMember("storage").getMember("blob").getMember(s2).getAMember() and
    startingNode = n.getACall().getReturn().getAValueReachableFromSource().asExpr().getAFlowNode() and
    startingNode.strictlyReaches(ctrlFlowNode) and
    attr.getAFlowNode() = ctrlFlowNode and
    attr.getName() = s1 and
    ctrlFlowNode.strictlyReaches(ctrlFlowNodeUploadBlob) and
    attrUploadBlob.getAFlowNode() = ctrlFlowNodeUploadBlob and
    attrUploadBlob.getName() = s3 and
    not exists(
      Attribute attrBarrier, ControlFlowNode ctrlFlowNodeBarrier, AssignStmt astmt2, StrConst uc
    |
      startingNode.strictlyReaches(ctrlFlowNodeBarrier) and
      attrBarrier.getAFlowNode() = ctrlFlowNodeBarrier and
      attrBarrier.getName() = "encryption_version" and
      uc = astmt2.getValue() and
      uc.getText() in ["'2.0'", "2.0"] and
      astmt2.getATarget().getAChildNode*() = attrBarrier and
      ctrlFlowNodeBarrier.strictlyReaches(ctrlFlowNodeUploadBlob)
    )
  )
}

from Call call, ControlFlowNode node
where isUnsafeClientSideAzureStorageEncryptionViaAttributes(call, node)
select node, "Unsafe usage of v1 version of Azure Storage client-side encryption."
