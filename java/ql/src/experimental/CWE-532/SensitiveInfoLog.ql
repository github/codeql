/**
 * @id java/sensitiveinfo-in-logfile
 * @name Insertion of sensitive information into log files
 * @description Writting sensitive information to log files can give valuable guidance to an attacker or expose sensitive user information.
 * @kind problem
 * @tags security
 *       external/cwe-532
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow
import PathGraph

/** Class of popular logging utilities **/
class LoggerType extends RefType {
    LoggerType() {
        this.hasQualifiedName("org.apache.log4j", "Category") or //Log4J
        this.hasQualifiedName("org.slf4j", "Logger")  //SLF4j
    }
}

/** Concatenated string with a variable that keeps sensitive information judging by its name **/
class CredentialExpr extends Expr {
    CredentialExpr() {
        exists (Variable v | this.(AddExpr).getAnOperand() = v.getAnAccess() | v.getName().regexpMatch(getACredentialRegex()))
    }
}

/** Source in concatenated string or variable itself  **/
class CredentialSource extends DataFlow::ExprNode {
    CredentialSource() {
        exists (
            Variable v | this.asExpr() = v.getAnAccess() | v.getName().regexpMatch(getACredentialRegex())
        ) or
        exists (
            this.asExpr().(AddExpr).getAnOperand().(CredentialExpr)  
        ) or
        exists (
            this.asExpr().(CredentialExpr)  
        )
    }
}

/**
  * Gets a regular expression for matching names of variables that indicate the value being held is a credential.
  */

private string getACredentialRegex() {
  result = "(?i).*pass(wd|word|code|phrase)(?!.*question).*" or
  result = "(?i).*(uid|uuid|puid|username|userid|url).*"
}

class SensitiveLoggingSink extends DataFlow::ExprNode {
    SensitiveLoggingSink() {
        exists(MethodAccess ma |
            ma.getMethod().getDeclaringType() instanceof LoggerType and
            (
                ma.getMethod().hasName("debug")
            ) and
            this.asExpr() = ma.getAnArgument()
        )
    }
}

class SensitiveLoggingConfig extends Configuration {
    SensitiveLoggingConfig() {
        this = "SensitiveLoggingConfig"
    }

    override predicate isSource(Node source) {
        source instanceof CredentialSource
    }

    override predicate isSink(Node sink) {
        sink instanceof SensitiveLoggingSink
    }
}

from Node source, Node sink, SensitiveLoggingConfig conf, MethodAccess ma
where conf.hasFlow(source, sink) and ma.getAnArgument() = source.asExpr() and ma.getAnArgument() = sink.asExpr()
select "Outputting sensitive information $@ in method call $@.", source, ma, "to log files"

