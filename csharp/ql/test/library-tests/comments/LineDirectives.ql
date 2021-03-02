import csharp

query predicate default(DefaultLineDirective line) { any() }

query predicate hidden(HiddenLineDirective line) { any() }

query predicate lines_file(NumericLineDirective line, int l, File file) {
  line.getLine() = l and line.getReferencedFile() = file
}

query predicate lines_no_file(NumericLineDirective line, int l) {
  line.getLine() = l and not exists(line.getReferencedFile())
}

query predicate succ(LineDirective d, LineDirective succ) { d.getSuccLineDirective() = succ }

query predicate last(LineDirective d) { not d.hasSuccLineDirective() }

query predicate mapped(SourceLocation l1, Location l2) { l1.getMappedLocation() = l2 }
