/**
 * @name Load 3rd party classes or code ('unsafe reflection') without signature check
 * @description Load classes or code from 3rd party package without checking the 
 *              package signature but only rely on package name.
 *              This makes it susceptible to package namespace squatting 
 *              potentially leading to arbitrary code execution.
 * @problem.severity error
 * @precision high
 * @id java/unsafe-reflection
 * @tags security
 *       experimental
 *       external/cwe/cwe-470
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
 
ControlFlowNode getControlFlowNodeSuccessor(ControlFlowNode node)
{
    result = node.getASuccessor()
}

MethodAccess getClassLoaderReachableMethodAccess(DataFlow::Node node)
{
    exists(
        MethodAccess maGetClassLoader, ControlFlowNode cfnGetClassLoader, ControlFlowNode cfnSuccessor |
        maGetClassLoader.getCallee().getName() = "getClassLoader" and
        maGetClassLoader.getQualifier() = node.asExpr() and
        maGetClassLoader.getControlFlowNode() = cfnGetClassLoader and
        //cfnGetClassLoader.getASuccessor+() = cfnSuccessor and
        getControlFlowNodeSuccessor+(cfnGetClassLoader) = cfnSuccessor and
        cfnSuccessor instanceof MethodAccess and
        result = cfnSuccessor.(MethodAccess)
    )
}

MethodAccess getDangerousReachableMethodAccess(MethodAccess ma)
{
    (ma.getCallee().hasName("getMethod") or
     ma.getCallee().hasName("getDeclaredMethod")) and
    (( 
        exists(MethodAccess maInvoke | 
            //ma.getControlFlowNode().getASuccessor*() = maInvoke and
            getControlFlowNodeSuccessor+(ma.getControlFlowNode()) = maInvoke and
            maInvoke.getCallee().hasName("invoke") and
            result = maInvoke
            )
    ) or
    (
        exists(AssignExpr ae, VarAccess va1, VarAccess va2, MethodAccess maInvoke |
            ae.getSource() = ma and
            ae.getDest() = va1 and
            maInvoke.getQualifier() = va2 and
            va1.getVariable() = va2.getVariable() and
            result = maInvoke
            )
    ))
}
 
predicate isSignaturesChecked(MethodAccess maCreatePackageContext)
{
    exists(
        MethodAccess maCheckSignatures |
        maCheckSignatures.getCallee().getDeclaringType().getQualifiedName() = "android.content.pm.PackageManager" and
        maCheckSignatures.getCallee().getName() = "checkSignatures" and
        //maCheckSignatures.getArgument(0).toString() = maCreatePackageContext.getArgument(0).toString()
        TaintTracking::localTaint(
            DataFlow::exprNode(maCheckSignatures.getArgument(0)), 
            DataFlow::exprNode(maCreatePackageContext.getArgument(0)))
    )
}
 
from 
    MethodAccess maCreatePackageContext, 
    LocalVariableDeclExpr lvdePackageContext,
    DataFlow::Node sinkPackageContext,
    MethodAccess maGetMethod,
    MethodAccess maInvoke 
where
    (maCreatePackageContext.getCallee().getDeclaringType().getQualifiedName() = "android.content.ContextWrapper" or
     maCreatePackageContext.getCallee().getDeclaringType().getQualifiedName() = "android.content.Context") and 
    maCreatePackageContext.getCallee().getName() = "createPackageContext" and
    not isSignaturesChecked(maCreatePackageContext) and
    lvdePackageContext.getEnclosingStmt() = maCreatePackageContext.getEnclosingStmt() and
    TaintTracking::localTaint(DataFlow::exprNode(lvdePackageContext.getAnAccess()), sinkPackageContext) and
    getClassLoaderReachableMethodAccess(sinkPackageContext) = maGetMethod and
    getDangerousReachableMethodAccess(maGetMethod) = maInvoke
select
    lvdePackageContext, 
    sinkPackageContext, 
    maGetMethod,
    maInvoke,
    "Potential arbitary code execution due to class loading without package signature checking."
 
