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

API::Node getClient() {
  result =
    API::moduleImport("azure")
        .getMember("storage")
        .getMember("blob")
        .getMember(["ContainerClient", "BlobClient", "BlobServiceClient"])
        .getAMember()
        .getReturn()
}

module AzureBlobClientConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    exists(DataFlow::AttrWrite attr |
      node = getClient().getAValueReachableFromSource() and
      attr.accesses(node, ["key_encryption_key", "key_resolver_function"])
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(DataFlow::AttrWrite attr |
      node = getClient().getAValueReachableFromSource() and
      attr.accesses(node, "encryption_version") and
      attr.getValue().asExpr().(StrConst).getText() in ["'2.0'", "2.0"]
    )
  }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::MethodCallNode call |
      call = getClient().getMember("upload_blob").getACall() and
      node = call.getObject()
    )
  }
}

module AzureBlobClient = DataFlow::Global<AzureBlobClientConfig>;

import AzureBlobClient::PathGraph

from AzureBlobClient::PathNode source, AzureBlobClient::PathNode sink
where AzureBlobClient::flowPath(source, sink)
select sink, source, sink, "Unsafe usage of v1 version of Azure Storage client-side encryption"
