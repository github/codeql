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

API::Node getBlobServiceClient() {
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("BlobServiceClient")
        .getReturn()
  or
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("BlobServiceClient")
        .getMember("from_connection_string")
        .getReturn()
}

API::CallNode getTransitionToContainerClient() {
  result = getBlobServiceClient().getMember("get_container_client").getACall()
  or
  result = getBlobClient().getMember("_get_container_client").getACall()
}

API::Node getContainerClient() {
  result = getTransitionToContainerClient().getReturn()
  or
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("ContainerClient")
        .getReturn()
  or
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("ContainerClient")
        .getMember(["from_connection_string", "from_container_url"])
        .getReturn()
}

API::CallNode getTransitionToBlobClient() {
  result = [getBlobServiceClient(), getContainerClient()].getMember("get_blob_client").getACall()
}

API::Node getBlobClient() {
  result = getTransitionToBlobClient().getReturn()
  or
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("BlobClient")
        .getReturn()
  or
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember("BlobClient")
        .getMember(["from_connection_string", "from_blob_url"])
        .getReturn()
}

API::Node anyClient() { result in [getBlobServiceClient(), getContainerClient(), getBlobClient()] }

newtype TAzureFlowState =
  MkUsesV1Encryption() or
  MkUsesNoEncryption()

module AzureBlobClientConfig implements DataFlow::StateConfigSig {
  class FlowState = TAzureFlowState;

  predicate isSource(DataFlow::Node node, FlowState state) {
    state = MkUsesNoEncryption() and
    node = anyClient().asSource()
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    exists(state) and
    exists(DataFlow::AttrWrite attr |
      node = anyClient().getAValueReachableFromSource() and
      attr.accesses(node, "encryption_version") and
      attr.getValue().asExpr().(StrConst).getText() in ["'2.0'", "2.0"]
    )
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
    node1 = node2 and
    state1 = MkUsesNoEncryption() and
    state2 = MkUsesV1Encryption() and
    exists(DataFlow::AttrWrite attr |
      node1 = anyClient().getAValueReachableFromSource() and
      attr.accesses(node1, ["key_encryption_key", "key_resolver_function"])
    )
  }

  predicate isSink(DataFlow::Node node, FlowState state) {
    state = MkUsesV1Encryption() and
    exists(DataFlow::MethodCallNode call |
      call = getBlobClient().getMember("upload_blob").getACall() and
      node = call.getObject()
    )
  }
}

module AzureBlobClient = DataFlow::GlobalWithState<AzureBlobClientConfig>;

import AzureBlobClient::PathGraph

from AzureBlobClient::PathNode source, AzureBlobClient::PathNode sink
where AzureBlobClient::flowPath(source, sink)
select sink, source, sink, "Unsafe usage of v1 version of Azure Storage client-side encryption"
