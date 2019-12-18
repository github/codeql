private import csharp

/**
 * Get the actual type of the specified variable, as opposed to the declared
 * type.
 */
Type getVariableType(Variable v) {
  // C# doesn't seem to have any cases where the variable's actual type differs
  // from its declared type.
  result = v.getType()
}

predicate hasCaseEdge(CaseStmt caseStmt, string minValue, string maxValue) {
  minValue = caseStmt.getPattern().getValue() and
  maxValue = minValue
}
