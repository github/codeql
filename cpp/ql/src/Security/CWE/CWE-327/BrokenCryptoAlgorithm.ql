/**
 * @name Use of a broken or risky cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can allow
 *              an attacker to compromise security.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cpp/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */

import cpp
import semmle.code.cpp.security.Encryption

/**
 * A function which may relate to an insecure encryption algorithm.
 */
Function getAnInsecureEncryptionFunction() {
  (
    isInsecureEncryption(result.getName()) or
    isInsecureEncryption(result.getAParameter().getName())
  ) and
  exists(result.getACallToThisFunction())
}

/**
 * A function with additional evidence it is related to encryption.
 */
Function getAdditionalEvidenceFunction() {
  (
    isEncryptionAdditionalEvidence(result.getName()) or
    isEncryptionAdditionalEvidence(result.getAParameter().getName())
  ) and
  exists(result.getACallToThisFunction())
}

/**
 * A macro which may relate to an insecure encryption algorithm.
 */
Macro getAnInsecureEncryptionMacro() {
  isInsecureEncryption(result.getName()) and
  exists(result.getAnInvocation())
}

/**
 * A macro with additional evidence it is related to encryption.
 */
Macro getAdditionalEvidenceMacro() {
  isEncryptionAdditionalEvidence(result.getName()) and
  exists(result.getAnInvocation())
}

/**
 * A function call we have a high confidence is related to use of an insecure
 * encryption algorithm.
 */
class InsecureFunctionCall extends FunctionCall {
  InsecureFunctionCall() {
    // find use of an insecure algorithm name
    (
      getTarget() = getAnInsecureEncryptionFunction()
      or
      exists(MacroInvocation mi |
        mi.getAGeneratedElement() = this.getAChild*() and
        mi.getMacro() = getAnInsecureEncryptionMacro()
      )
    ) and
    // find additional evidence that this function is related to encryption.
    (
      getTarget() = getAdditionalEvidenceFunction()
      or
      exists(MacroInvocation mi |
        mi.getAGeneratedElement() = this.getAChild*() and
        mi.getMacro() = getAdditionalEvidenceMacro()
      )
    )
  }

  string description() { result = "function call" }
}

from InsecureFunctionCall c
select c, "This " + c.description() + " specifies a broken or weak cryptographic algorithm."
