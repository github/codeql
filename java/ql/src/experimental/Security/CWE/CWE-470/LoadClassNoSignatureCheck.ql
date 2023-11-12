/**
 * @name Load 3rd party classes or code ('unsafe reflection') without signature check
 * @description Load classes or code from 3rd party package without checking the 
 *              package signature but only rely on package name.
 *              This makes it susceptible to package namespace squatting 
 *              potentially leading to arbitrary code execution.
 * @kind path-problem
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

predicate doesPackageContextLeadToInvokeMethod(
  DataFlow::Node sinkPackageContext, MethodAccess maInvoke

)
{
    exists(
        MethodAccess maGetClassLoader,
        MethodAccess maLoadClass,
        MethodAccess maGetMethod |
        maGetClassLoader.getCallee().getName() = "getClassLoader" and
        maGetClassLoader.getQualifier() = sinkPackageContext.asExpr() and
        maLoadClass.getCallee().getName() = "loadClass" and
        maLoadClass.getQualifier() = maGetClassLoader and
        // check for arbitray code execution 
        maGetMethod.getCallee().getName() = "getMethod" and
        maGetMethod.getQualifier() = maLoadClass and
        maInvoke.getCallee().getName() = "invoke" and
        maInvoke.getQualifier() = maGetMethod
    )
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
    MethodAccess maInvoke
where
    maCreatePackageContext.getCallee().getDeclaringType().getQualifiedName() = "android.content.ContextWrapper" and
    maCreatePackageContext.getCallee().getName() = "createPackageContext" and

    not isSignaturesChecked(maCreatePackageContext) and

    lvdePackageContext.getEnclosingStmt() = maCreatePackageContext.getEnclosingStmt() and
    TaintTracking::localTaint(DataFlow::exprNode(lvdePackageContext.getAnAccess()), sinkPackageContext) and

    doesPackageContextLeadToInvokeMethod(sinkPackageContext, maInvoke)
select
    lvdePackageContext, 
    sinkPackageContext, 
    maInvoke,
    maCreatePackageContext.getArgument(0)

