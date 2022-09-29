/**
 * @name Detects a modified FNV function
 * @description Possible indication of Solorigate. Detects a modified FNV1 function, where there is an additional xor using a literal after the regular FNV hash
 * @kind problem
 * @tags security
 *       solorigate
 * @precision high
 * @id cs/solorigate/modified-fnv-function-detection
 * @problem.severity error
 */

import csharp
import Solorigate
import experimental.code.csharp.Cryptography.NonCryptographicHashes

from Variable v, Literal l, LoopStmt loop, Expr additional_xor
where
  maybeUsedInFnvFunction(v, _, _, loop) and
  (
    exists(BitwiseXorExpr xor2 | xor2.getAnOperand() = l and additional_xor = xor2 |
      loop.getAControlFlowExitNode().getASuccessor*() = xor2.getAControlFlowNode() and
      xor2.getAnOperand() = v.getAnAccess()
    )
    or
    exists(AssignXorExpr xor2 | xor2.getAnOperand() = l and additional_xor = xor2 |
      loop.getAControlFlowExitNode().getASuccessor*() = xor2.getAControlFlowNode() and
      xor2.getAnOperand() = v.getAnAccess()
    )
  )
select l, "This literal is used in an $@ after an FNV-like hash calculation with variable $@.",
  additional_xor, "additional xor", v, v.toString()
