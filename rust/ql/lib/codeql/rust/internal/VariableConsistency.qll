/**
 * Provides logic for recognizing variable inconsistencies.
 */

private import rust

query predicate multipleVariableTargets(VariableAccess va, Variable v1) {
  va = v1.getAnAccess() and
  strictcount(va.getVariable()) > 1
}
