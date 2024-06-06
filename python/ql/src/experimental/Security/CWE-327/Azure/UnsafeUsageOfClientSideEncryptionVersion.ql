/**
 * @name Unsafe usage of v1 version of Azure Storage client-side encryption.
 * @description Using version v1 of Azure Storage client-side encryption is insecure, and may enable an attacker to decrypt encrypted data
 * @kind path-problem
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

API::Node getBlobServiceClient(boolean isSource) {
  isSource = true and
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("BlobServiceClient")
        .getReturn()
  or
  isSource = true and
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("BlobServiceClient")
        .getMember("from_connection_string")
        .getReturn()
}

API::CallNode getTransitionToContainerClient() {
  result = getBlobServiceClient(_).getMember("get_container_client").getACall()
  or
  result = getBlobClient(_).getMember("_get_container_client").getACall()
}

API::Node getContainerClient(boolean isSource) {
  isSource = false and
  result = getTransitionToContainerClient().getReturn()
  or
  isSource = true and
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("ContainerClient")
        .getReturn()
  or
  isSource = true and
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("ContainerClient")
        .getMember(["from_connection_string", "from_container_url"])
        .getReturn()
}

API::CallNode getTransitionToBlobClient() {
  result = [getBlobServiceClient(_), getContainerClient(_)].getMember("get_blob_client").getACall()
}

API::Node getBlobClient(boolean isSource) {
  isSource = false and
  result = getTransitionToBlobClient().getReturn()
  or
  isSource = true and
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("BlobClient")
        .getReturn()
  or
  isSource = true and
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("BlobClient")
        .getMember(["from_connection_string", "from_blob_url"])
        .getReturn()
}

API::Node anyClient(boolean isSource) {
  result in [getBlobServiceClient(isSource), getContainerClient(isSource), getBlobClient(isSource)]
}

newtype TAzureFlowState =
  MkUsesV1Encryption() or
  MkUsesNoEncryption()

private module AzureBlobClientConfig implements DataFlow::StateConfigSig {
  class FlowState = TAzureFlowState;

  predicate isSource(DataFlow::Node node, FlowState state) {
    state = MkUsesNoEncryption() and
    node = anyClient(true).asSource()
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    exists(state) and
    exists(DataFlow::AttrWrite attr |
      node = anyClient(_).getAValueReachableFromSource() and
      attr.accesses(node, "encryption_version") and
      attr.getValue().asExpr().(StringLiteral).getText() in ["'2.0'", "2.0"]
    )
    or
    // small optimization to block flow with no encryption out of the post-update node
    // for the attribute assignment.
    isAdditionalFlowStep(_, MkUsesNoEncryption(), node, MkUsesV1Encryption()) and
    state = MkUsesNoEncryption()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(DataFlow::MethodCallNode call |
      call in [getTransitionToContainerClient(), getTransitionToBlobClient()] and
      node1 = call.getObject() and
      node2 = call
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    node1 = node2.(DataFlow::PostUpdateNode).getPreUpdateNode() and
    state1 = MkUsesNoEncryption() and
    state2 = MkUsesV1Encryption() and
    exists(DataFlow::AttrWrite attr |
      node1 = anyClient(_).getAValueReachableFromSource() and
      attr.accesses(node1, ["key_encryption_key", "key_resolver_function"])
    )
  }

  predicate isSink(DataFlow::Node node, FlowState state) {
    state = MkUsesV1Encryption() and
    exists(DataFlow::MethodCallNode call |
      call = getBlobClient(_).getMember("upload_blob").getACall() and
      node = call.getObject()
    )
  }
}

module AzureBlobClientFlow = DataFlow::GlobalWithState<AzureBlobClientConfig>;

import AzureBlobClientFlow::PathGraph

from AzureBlobClientFlow::PathNode source, AzureBlobClientFlow::PathNode sink
where AzureBlobClientFlow::flowPath(source, sink)
select sink, source, sink, "Unsafe usage of v1 version of Azure Storage client-side encryption"
