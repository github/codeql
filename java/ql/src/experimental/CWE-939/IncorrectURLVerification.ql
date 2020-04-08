/**
 * @id java/incorrect-url-verification
 * @name Insertion of sensitive information into log files
 * @description Apps that rely on URL parsing to verify that a given URL is pointing to a trusted server are susceptible to wrong ways of URL parsing and verification. 
 * @kind problem
 * @tags security
 *       external/cwe-939
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import DataFlow
import PathGraph


/**
 * The Java class `android.net.Uri` and `java.net.URL`.
 */
class Uri extends RefType {
    Uri() {
        hasQualifiedName("android.net", "Uri") or
        hasQualifiedName("java.net", "URL")
    }
}

/**
 * The method `getHost()` declared in `android.net.Uri` and `java.net.URL`.
 */
class UriGetHostMethod extends Method {
    UriGetHostMethod() {
        getDeclaringType() instanceof Uri and
        hasName("getHost") and
        getNumberOfParameters() = 0
    }
}

/**
 * A library method that acts like `String.format` by formatting a number of
 * its arguments according to a format string.
 */
class HostVerificationMethodAccess extends MethodAccess {
    HostVerificationMethodAccess() {
        (

            this.getMethod().hasName("endsWith") or
            this.getMethod().hasName("contains") or
            this.getMethod().hasName("indexOf")
        ) and
        this.getMethod().getNumberOfParameters() = 1 and 
        (
            this.getArgument(0).(StringLiteral).getRepresentedString().charAt(0) != "." or  //string constant comparison
            this.getArgument(0).(AddExpr).getLeftOperand().(VarAccess).getVariable().getAnAssignedValue().(StringLiteral).getRepresentedString().charAt(0) != "." or   //var1+var2, check var1 starts with "."
            this.getArgument(0).(AddExpr).getLeftOperand().(StringLiteral).getRepresentedString().charAt(0) != "." or  //"."+var2, check string constant "."
            exists (MethodAccess ma | this.getArgument(0) = ma and ma.getMethod().hasName("getString") and ma.getArgument(0).toString().indexOf("R.string") = 0) or  //res.getString(R.string.key)
            this.getArgument(0).(VarAccess).getVariable().getAnAssignedValue().(StringLiteral).getRepresentedString().charAt(0) != "."  //check variable starts with "."
        )
    }
}

from UriGetHostMethod um, MethodAccess uma, HostVerificationMethodAccess hma
where hma.getQualifier() = uma and uma.getMethod() = um
select "Potentially improper URL verification with $@ in $@ having $@.",
  hma, hma.getFile(), hma.getArgument(0), "user-provided value"