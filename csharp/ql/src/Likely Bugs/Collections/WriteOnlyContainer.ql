/**
 * @name Container contents are never accessed
 * @description A collection or map whose contents are never queried or accessed is useless.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/unused-collection
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import csharp
import semmle.code.csharp.commons.Collections

from Variable v
where
  v.getType() instanceof CollectionType and
  (
    v instanceof LocalVariable or
    v = any(Field f | not f.isEffectivelyPublic())
  ) and
  forex(Access a | a = v.getAnAccess() |
    a = any(ModifierMethodCall m).getQualifier() or
    a = any(Assignment ass | ass.getRValue() instanceof ObjectCreation).getLValue()
  ) and
  not v = any(ForeachStmt fs).getVariable() and
  not v = any(BindingPatternExpr vpe).getVariableDeclExpr().getVariable() and
  not v = any(Attribute a).getTarget()
select v, "The contents of this container are never accessed."
