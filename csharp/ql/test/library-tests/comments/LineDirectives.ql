import csharp

query predicate default(DefaultLineDirective line) { any() }

query predicate hidden(HiddenLineDirective line) { any() }

query predicate lines(NumericLineDirective line, int l, string file) {
  line.getLine() = l and
  if line.hasFileName() then line.getFileName() = file else file = "no file"
}

query predicate succ(LineDirective d, LineDirective succ) { d.getSuccLineDirective() = succ }

query predicate last(LineDirective d) { not d.hasSuccLineDirective() }
