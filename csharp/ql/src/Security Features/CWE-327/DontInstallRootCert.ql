/**
 * @name Do not add certificates to the system root store.
 * @description Application- or user-specific certificates placed in the system root store could
 *              weaken security for other processing running on the same system.
 * @kind path-problem
 * @id cs/adding-cert-to-root-store
 * @problem.severity error
 * @tags security
 *       external/cwe/cwe-327
 */

import csharp
import semmle.code.csharp.dataflow.DataFlow::DataFlow
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

class AddCertToRootStoreConfig extends DataFlow::Configuration {
  AddCertToRootStoreConfig() { this = "Adding Certificate To Root Store" }

  override predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc | oc = source.asExpr() |
      oc
          .getType()
          .(RefType)
          .hasQualifiedName("System.Security.Cryptography.X509Certificates.X509Store") and
      oc.getArgument(0).(Access).getTarget().hasName("Root")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      (
        mc
            .getTarget()
            .hasQualifiedName("System.Security.Cryptography.X509Certificates.X509Store", "Add") or
        mc
            .getTarget()
            .hasQualifiedName("System.Security.Cryptography.X509Certificates.X509Store", "AddRange")
      ) and
      sink.asExpr() = mc.getQualifier()
    )
  }
}

from DataFlow::PathNode oc, DataFlow::PathNode mc, AddCertToRootStoreConfig config
where config.hasFlowPath(oc, mc)
select mc.getNode(), oc, mc, "Certificate added to the root certificate store."
