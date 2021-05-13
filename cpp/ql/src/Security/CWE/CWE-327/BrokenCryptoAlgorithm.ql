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
 * An enum constant which may relate to an insecure encryption algorithm.
 */
EnumConstant getAnInsecureEncryptionEnumConst() {
  isInsecureEncryption(result.getName())
}

/**
 * An enum constant with additional evidence it is related to encryption.
 */
EnumConstant getAdditionalEvidenceEnumConst() {
  isEncryptionAdditionalEvidence(result.getName())
}

/**
 * A function call we have a high confidence is related to use of an insecure
 * encryption algorithm.
 */
class InsecureFunctionCall extends FunctionCall {
  Element blame;
  string explain;

  InsecureFunctionCall() {
    // find use of an insecure algorithm name
    (
      getTarget() = getAnInsecureEncryptionFunction() and
      blame = this and
      explain = "function call"
      or
      exists(MacroInvocation mi |
        mi.getAGeneratedElement() = this.getAChild*() and
        mi.getMacro() = getAnInsecureEncryptionMacro() and
        blame = mi and
        explain = "macro invocation"
      )
      or
      exists(EnumConstantAccess ec |
        ec = this.getAChild*() and
        ec.getTarget() = getAnInsecureEncryptionEnumConst() and
        blame = ec and
        explain = "enum constant access"
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
      or
      exists(EnumConstantAccess ec |
        ec = this.getAChild*() and
        ec.getTarget() = getAdditionalEvidenceEnumConst()
      )
    )
  }

  Element getBlame() {
    result = blame
  }

  string getDescription() {
     result = explain
  }
}

from InsecureFunctionCall c
select c.getBlame(), "This " + c.getDescription() + " specifies a broken or weak cryptographic algorithm."
