/**
 * @name Unused value
 * @description Unused values may be an indication that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id rust/unused-value
 * @tags maintainability
 */

import rust
import codeql.rust.dataflow.Ssa
import codeql.rust.dataflow.internal.SsaImpl
import UnusedVariable

from AstNode write, Ssa::Variable v
where
  variableWrite(write, v) and
  // SSA definitions are only created for live writes
  not write = any(Ssa::WriteDefinition def).getWriteAccess().getAstNode() and
  // avoid overlap with the unused variable query
  not isUnused(v) and
  not v instanceof DiscardVariable and
  not write.isInMacroExpansion()
select write, "Variable $@ is assigned a value that is never used.", v, v.getName()
