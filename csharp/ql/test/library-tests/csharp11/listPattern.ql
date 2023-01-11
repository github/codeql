import csharp

private string childPatterns(ListPatternExpr e) {
  result = concat(string child, int n | child = e.getPattern(n).toString() | child, ", " order by n)
}

query predicate listPattern(ListPatternExpr pattern, string children) {
  pattern.getFile().getStem() = "ListPattern" and
  children = childPatterns(pattern)
}

query predicate slicePattern(SlicePatternExpr pattern, string s) {
  pattern.getFile().getStem() = "ListPattern" and
  exists(string child |
    if exists(pattern.getPattern()) then child = pattern.getPattern().toString() else child = ""
  |
    s = pattern.toString() + ":" + child
  )
}
