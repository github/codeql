import rust

query predicate getFormat(FormatArgsExpr arg, Format format, int index) {
  format = arg.getFormat(index)
}

query predicate getArgumentRef(Format format, FormatArgument arg) { arg = format.getArgumentRef() }

query predicate getWidthArgument(Format format, FormatArgument arg) {
  arg = format.getWidthArgument()
}

query predicate getPrecisionArgument(Format format, FormatArgument arg) {
  arg = format.getPrecisionArgument()
}

query predicate getIndex(PositionalFormatArgument arg, int index) { arg.getIndex() = index }

query predicate getName(NamedFormatArgument arg, string name) { arg.getName() = name }
