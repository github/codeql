/**
 * @name Load 3rd party classes or code ('unsafe reflection') without signature check
 * @description Load classes or code from 3rd party package without checking the 
 *              package signature but only rely on package name.
 *              This makes it susceptible to package namespace squatting 
 *              potentially leading to arbitrary code execution.
 * @problem.severity error
 * @precision high
 * @kind problem
 * @id java/unsafe-reflection
 * @tags security
 *       experimental
 *       external/cwe/cwe-470
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking


MethodAccess getClassLoaderReachableMethodAccess(DataFlow::Node node)
{
    exists(MethodAccess maGetClassLoader |
        maGetClassLoader.getCallee().getName() = "getClassLoader" and
        maGetClassLoader.getQualifier() = node.asExpr() and
        result = maGetClassLoader.getControlFlowNode().getASuccessor+()
    )
}

MethodAccess getDangerousReachableMethodAccess(MethodAccess ma)
{
  ma.getCallee().hasName(["getMethod", "getDeclaredMethod"]) and
  (
    result = ma.getControlFlowNode().getASuccessor*() and
    result.getCallee().hasName("invoke")
    or
    exists(AssignExpr ae |
      ae.getSource() = ma and
      ae.getDest().(VarAccess).getVariable() =
        result.getQualifier().(VarAccess).getVariable()
    )
  )
}

module SignaturePackageConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
exists(MethodAccess maCheckSignatures |
      maCheckSignatures
          .getMethod()
          .hasQualifiedName("android.content.pm", "PackageManager", "checkSignatures") and
      source.asExpr() = maCheckSignatures.getArgument(0)
    )
    }

    predicate isSink(DataFlow::Node sink) {
        exists (MethodAccess maCreatePackageContext |
            (maCreatePackageContext.getCallee().getDeclaringType().getQualifiedName() = "android.content.ContextWrapper" or
             maCreatePackageContext.getCallee().getDeclaringType().getQualifiedName() = "android.content.Context") and 
            maCreatePackageContext.getCallee().getName() = "createPackageContext" and
            sink.asExpr() = maCreatePackageContext.getArgument(0)
            )                
    }
}

module SigPkgCfg = TaintTracking::Global<SignaturePackageConfig>;

predicate isSignaturesChecked(MethodAccess maCreatePackageContext)
{
  SigPkgCfg::flowToExpr(maCreatePackageContext.getArgument(0))
}
 
from
  MethodAccess maCreatePackageContext, LocalVariableDeclExpr lvdePackageContext,
  DataFlow::Node sinkPackageContext, MethodAccess maGetMethod, MethodAccess maInvoke
where
  maCreatePackageContext
      .getMethod()
      .hasQualifiedName("android.content", ["ContextWrapper", "Context"], "createPackageContext") and
  not isSignaturesChecked(maCreatePackageContext) and
  lvdePackageContext.getEnclosingStmt() = maCreatePackageContext.getEnclosingStmt() and
  TaintTracking::localTaint(DataFlow::exprNode(lvdePackageContext.getAnAccess()), sinkPackageContext) and
  getClassLoaderReachableMethodAccess(sinkPackageContext) = maGetMethod and
  getDangerousReachableMethodAccess(maGetMethod) = maInvoke
select maInvoke, "Potential arbitary code execution due to $@ without $@ signature checking.", sinkPackageContext, "class loading", sinkPackageContext, "package"
 
