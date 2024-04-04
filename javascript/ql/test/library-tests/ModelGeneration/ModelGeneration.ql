private import javascript
private import semmle.javascript.endpoints.EndpointNaming as EndpointNaming
private import semmle.javascript.frameworks.data.internal.ApiGraphModels as Shared

module ModelExportConfig implements ModelExportSig {
  predicate shouldContain(API::Node node) {
    node.getAValueReachingSink() instanceof DataFlow::FunctionNode
  }

  predicate mustBeNamed(API::Node node) { shouldContain(node) }

  predicate shouldContainType(string type) { Shared::isRelevantType(type) }
}

module Exported = ModelExport<ModelExportConfig>;

query predicate typeModel = Exported::typeModel/3;

query predicate summaryModel = Exported::summaryModel/5;
