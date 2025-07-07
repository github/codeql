/**
 * @name Insecure execution policy
 * @description Calling `Set-ExecutionPolicy` with an insecure execution policy argument may allow
 *              attackers to execute malicious scripts or load malicious configurations.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id powershell/microsoft/public/insecure-execution-policy
 * @tags correctness
 *       security
 *       external/cwe/cwe-250
 */

import powershell

/** A call to `Set-ExecutionPolicy`. */
class SetExecutionPolicy extends CmdCall {
  SetExecutionPolicy() { this.getAName() = "Set-ExecutionPolicy" }

  /** Gets the execution policy of this call to `Set-ExecutionPolicy`. */
  Expr getExecutionPolicy() {
    result = this.getNamedArgument("executionpolicy")
    or
    not this.hasNamedArgument("executionpolicy") and
    result = this.getPositionalArgument(0)
  }

  /** Gets the scope of this call to `Set-ExecutionPolicy`, if any. */
  Expr getScope() {
    result = this.getNamedArgument("scope")
    or
    not this.hasNamedArgument("scope") and
    (
      // The ExecutionPolicy argument has position 0 so if is present as a
      // named argument then the position of the Scope argument is 0. However,
      // if the ExecutionPolicy is present as a positional argument then the
      // Scope argument is at position 1.
      if this.hasNamedArgument("executionpolicy")
      then result = this.getPositionalArgument(0)
      else result = this.getPositionalArgument(1)
    )
  }

  /** Holds if the argument `flag` is supplied with a `$true` value. */
  predicate isForced() { this.getNamedArgument("force").getValue().asBoolean() = true }
}

class Process extends Expr {
  Process() { this.getValue().stringMatches("process") }
}

class Bypass extends Expr {
  Bypass() { this.getValue().stringMatches("Bypass") }
}

class BypassSetExecutionPolicy extends SetExecutionPolicy {
  BypassSetExecutionPolicy() { this.getExecutionPolicy() instanceof Bypass }
}

from BypassSetExecutionPolicy setExecutionPolicy
where
  not setExecutionPolicy.getScope() instanceof Process and
  setExecutionPolicy.isForced()
select setExecutionPolicy, "Insecure use of 'Set-ExecutionPolicy'."
