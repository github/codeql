/**
 * @name Detect JHipster Generator Vulnnerability CVE-2019-16303
 * @description Detector for the CVE-2019-16303 vulnerability that existed in the JHipster code generator.
 * @kind problem
 * @problem.severity error
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

private class PredictableApacheRandomStringUtilsMethodAccess extends MethodAccess {
  PredictableApacheRandomStringUtilsMethodAccess() {
    this.getMethod() instanceof PredictableApacheRandomStringUtilsMethod
  }
}

private class VulnerableJHipsterRandomUtilClass extends Class {
  VulnerableJHipsterRandomUtilClass() {
    // The package name that JHipster generated the 'RandomUtil' class in was dynamic. Thus 'hasQualifiedName' can not be used here.
    getName() = "RandomUtil"
  }
}

private class VulnerableJHipsterRandomUtilMethod extends Method {
  VulnerableJHipsterRandomUtilMethod() {
    this.getDeclaringType() instanceof VulnerableJHipsterRandomUtilClass and
    this.getName().matches("generate%") and
    this.getReturnType() instanceof TypeString and
    exists(ReturnStmt s |
      s = this.getBody().(SingletonBlock).getStmt() and
      s.getResult() instanceof PredictableApacheRandomStringUtilsMethodAccess
    )
  }
}

from VulnerableJHipsterRandomUtilMethod method
select method,
  "Weak random number generator used in security sensitive method (JHipster CVE-2019-16303)."
