/** Provides classes related to the namespace `System.Security`. */

import csharp
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.frameworks.System

/** The `System.Security` namespace. */
class SystemSecurityNamespace extends Namespace {
  SystemSecurityNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Security")
  }
}

/** A class in the `System.Security` namespace. */
class SystemSecurityClass extends Class {
  SystemSecurityClass() { this.getNamespace() instanceof SystemSecurityNamespace }
}

/** Data flow for some collection like classes in `System.Security.*`. */
private class SystemSecurityPolicyApplicationTrustCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Security.Permissions;KeyContainerPermissionAccessEntryCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Security.Policy;ApplicationTrustCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Security.Policy;Evidence;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
      ]
  }
}
