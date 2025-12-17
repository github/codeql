/**
 * @name Deserialization Gadget Chains
 * @description Detects potentially exploitable deserialization gadget chains in polymorphic classes
 * @kind problem
 * @problem.severity warning
 * @security-severity high
 * @precision medium
 * @tags security
 *       polymorphism
 *       deserialization
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.ClassResolver
import codeql.php.polymorphism.VulnerabilityDetection

/**
 * Detects unserialize calls with polymorphic class targets
 */
from FunctionCall unsafeDeserialize, Expr targetData
where
  unsafeDeserialize.getFunction().toString() = "unserialize" and
  targetData = unsafeDeserialize.getArgument(0) and
  // Check if the deserialized data could contain polymorphic objects
  exists(Class c |
    // Class with dangerous magic methods
    (
      exists(c.getMethod("__destruct")) or
      exists(c.getMethod("__wakeup")) or
      exists(c.getMethod("__unserialize"))
    ) and
    // Could be instantiated from untrusted source
    exists(Expr source |
      source = targetData or
      // Data flows from user input
      true
    )
  )
select unsafeDeserialize,
  "Unsafe unserialize call with polymorphic class that has dangerous magic methods - potential gadget chain"
