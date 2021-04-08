/**
 * @name Missed 'readonly' opportunity
 * @description A private field where all assignments occur as part of the declaration or
 *              in a constructor in the same class can be 'readonly'.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/missed-readonly-modifier
 * @tags maintainability
 *       language-features
 */

import csharp

predicate defTargetsField(AssignableDefinition def, Field f) {
  def.getTarget().getUnboundDeclaration() = f
}

predicate isReadonlyCompatibleDefinition(AssignableDefinition def, Field f) {
  defTargetsField(def, f) and
  (
    def.getEnclosingCallable().(Constructor).getDeclaringType() = f.getDeclaringType()
    or
    def instanceof AssignableDefinitions::InitializerDefinition
  )
}

predicate canBeReadonly(Field f) {
  forex(AssignableDefinition def | defTargetsField(def, f) | isReadonlyCompatibleDefinition(def, f))
}

from Field f
where
  canBeReadonly(f) and
  not f.isConst() and
  not f.isReadOnly() and
  not f.isEffectivelyPublic()
select f, "Field '" + f.getName() + "' can be 'readonly'."
