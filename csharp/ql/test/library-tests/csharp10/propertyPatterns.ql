import csharp

query predicate propertyPatterns(PropertyPatternExpr exp) { any() }

query predicate propertyPatternChild(PropertyPatternExpr pp, int n, PatternExpr child) {
  child = pp.getPattern(n)
}

query predicate propertyPatternLabels(LabeledPatternExpr exp, string label) {
  label = exp.getLabel()
}
