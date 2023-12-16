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
    exists(MethodCall maGetClassLoader |
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
exists(MethodCall maCheckSignatures |
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
  MethodCall maCreatePackageContext, LocalVariableDeclExpr lvdePackageContext,
  Expr sinkPackageContext, MethodCall maGetMethod, MethodCall maInvoke
where
  maCreatePackageContext
      .getMethod()
      .hasQualifiedName("android.content", ["ContextWrapper", "Context"], "createPackageContext") and
  not isSignaturesChecked(maCreatePackageContext) and
  lvdePackageContext.getEnclosingStmt() = maCreatePackageContext.getEnclosingStmt() and
  TaintTracking::localExprTaint(lvdePackageContext.getAnAccess(), sinkPackageContext) and
  getClassLoaderReachableMethodCall(sinkPackageContext) = maGetMethod and
  getGetMethodMethodCall(maGetMethod) = maInvoke
select maInvoke, "Potential arbitary code execution due to $@ without $@ signature checking.", sinkPackageContext, "class loading", sinkPackageContext, "package"
 
