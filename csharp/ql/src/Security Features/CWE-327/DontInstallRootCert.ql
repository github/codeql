/**
 * @name Do not add certificates to the system root store.
 * @description Application- or user-specific certificates placed in the system root store could
 *              weaken security for other processing running on the same system.
 * @kind problem
 * @id cs/do-not-add-certs-to-root-store
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */
import csharp
import semmle.code.csharp.dataflow.DataFlow::DataFlow

class AddCertToRootStoreConfig extends DataFlow::Configuration {
  AddCertToRootStoreConfig() { this = "Adding Certificate To Root Store" }
 
  override predicate isSource(DataFlow::Node source) {     
 	 	exists(ObjectCreation oc | oc = source.asExpr().(ObjectCreation) | 
			oc.getType().(RefType).hasQualifiedName("System.Security.Cryptography.X509Certificates.X509Store") 
			and oc.getArgument(0).(Access).getTarget().hasName("Root")
		)
  }
 
  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
 	 			mc.getTarget().hasQualifiedName("System.Security.Cryptography.X509Certificates.X509Store", "Add")
 	 			and sink.asExpr() = mc.getQualifier()
    )
  }
}

from Expr oc, Expr mc, AddCertToRootStoreConfig config
where config.hasFlow(DataFlow::exprNode(oc), DataFlow::exprNode(mc))
select mc, "Do not add certificates to root certificate store"  

