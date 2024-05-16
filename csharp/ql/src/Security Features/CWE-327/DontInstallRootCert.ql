/**
 * @name Do not add certificates to the system root store.
 * @description Application- or user-specific certificates placed in the system root store could
 *              weaken security for other processing running on the same system.
 * @kind path-problem
 * @id cs/adding-cert-to-root-store
 * @problem.severity error
 * @security-severity 7.5
 * @tags security
 *       external/cwe/cwe-327
 */

import csharp
import semmle.code.csharp.dataflow.DataFlow::DataFlow
import AddCertToRootStore::PathGraph

module AddCertToRootStoreConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc | oc = source.asExpr() |
      oc.getType()
          .(RefType)
          .hasFullyQualifiedName("System.Security.Cryptography.X509Certificates", "X509Store") and
      oc.getArgument(0).(Access).getTarget().hasName("Root")
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      (
        mc.getTarget()
            .hasFullyQualifiedName("System.Security.Cryptography.X509Certificates", "X509Store",
              "Add") or
        mc.getTarget()
            .hasFullyQualifiedName("System.Security.Cryptography.X509Certificates", "X509Store",
              "AddRange")
      ) and
      sink.asExpr() = mc.getQualifier()
    )
  }
}

module AddCertToRootStore = DataFlow::Global<AddCertToRootStoreConfig>;

from AddCertToRootStore::PathNode oc, AddCertToRootStore::PathNode mc
where AddCertToRootStore::flowPath(oc, mc)
select mc.getNode(), oc, mc, "This certificate is added to the root certificate store."
