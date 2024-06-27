/**
 * @name Detect JHipster Generator Vulnerability CVE-2019-16303
 * @description Using a vulnerable version of JHipster to generate random numbers makes it easier for attackers to take over accounts.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision very-high
 * @id java/jhipster-prng
 * @tags security
 *       external/cwe/cwe-338
 */

import java
import semmle.code.java.frameworks.apache.Lang

private class PredictableApacheRandomStringUtilsMethod extends Method {
  PredictableApacheRandomStringUtilsMethod() {
    this.getDeclaringType() instanceof TypeApacheRandomStringUtils and
    // The one valid use of this type that uses SecureRandom as a source of data.
    not this.getName() = "random"
  }
}

private class PredictableApacheRandomStringUtilsMethodCall extends MethodCall {
  PredictableApacheRandomStringUtilsMethodCall() {
    this.getMethod() instanceof PredictableApacheRandomStringUtilsMethod
  }
}

private class VulnerableJHipsterRandomUtilClass extends Class {
  VulnerableJHipsterRandomUtilClass() {
    // The package name that JHipster generated the 'RandomUtil' class in was dynamic. Thus 'hasQualifiedName' can not be used here.
    this.getName() = "RandomUtil"
  }
}

private class VulnerableJHipsterRandomUtilMethod extends Method {
  VulnerableJHipsterRandomUtilMethod() {
    this.getDeclaringType() instanceof VulnerableJHipsterRandomUtilClass and
    this.getName().matches("generate%") and
    this.getReturnType() instanceof TypeString and
    exists(ReturnStmt s |
      s = this.getBody().(SingletonBlock).getStmt() and
      s.getResult() instanceof PredictableApacheRandomStringUtilsMethodCall
    )
  }
}

from VulnerableJHipsterRandomUtilMethod method
select method,
  "Weak random number generator used in security sensitive method (JHipster CVE-2019-16303)."
