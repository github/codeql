import csharp

query predicate linespan_directives(
  SpanLineDirective directive, int startLine, int startColumn, int endLine, int endColumn, File file
) {
  file = directive.getReferencedFile() and
  directive.span(startLine, startColumn, endLine, endColumn)
}

query predicate linespan_offset(SpanLineDirective directive, int offset, File file) {
  file = directive.getReferencedFile() and
  offset = directive.getOffset()
}
