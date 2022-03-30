import csharp

query predicate nullables(NullableDirective d, int setting, int target) {
  directive_nullables(d, setting, target)
}

query predicate succ(NullableDirective d, NullableDirective succ) {
  d.getSuccNullableDirective() = succ
}

query predicate last(NullableDirective d) { not d.hasSuccNullableDirective() }
