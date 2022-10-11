/** Provides definitions related to the namespace `System.CodeDom`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System.CodeDome` namespace. */
class SystemCodeDomNamespace extends Namespace {
  SystemCodeDomNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("CodeDom")
  }
}

/** Data flow for `System.CodeDom.CodeNamespaceImportCollection`. */
private class SystemCodeDomCodeNamespaceImportCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.CodeDom;CodeNamespaceImportCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual"
  }
}
