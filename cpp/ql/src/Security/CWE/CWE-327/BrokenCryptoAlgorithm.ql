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

abstract class InsecureCryptoSpec extends Locatable {
  abstract string description();
}

Function getAnInsecureFunction() {
  result.getName().regexpMatch(getInsecureAlgorithmRegex()) and
  exists(result.getACallToThisFunction())
}

class InsecureFunctionCall extends InsecureCryptoSpec, FunctionCall {
  InsecureFunctionCall() { this.getTarget() = getAnInsecureFunction() }

  override string description() { result = "function call" }

  override string toString() { result = FunctionCall.super.toString() }

  override Location getLocation() { result = FunctionCall.super.getLocation() }
}

Macro getAnInsecureMacro() {
  result.getName().regexpMatch(getInsecureAlgorithmRegex()) and
  exists(result.getAnInvocation())
}

class InsecureMacroSpec extends InsecureCryptoSpec, MacroInvocation {
  InsecureMacroSpec() { this.getMacro() = getAnInsecureMacro() }

  override string description() { result = "macro invocation" }

  override string toString() { result = MacroInvocation.super.toString() }

  override Location getLocation() { result = MacroInvocation.super.getLocation() }
}

from InsecureCryptoSpec c
select c, "This " + c.description() + " specifies a broken or weak cryptographic algorithm."
