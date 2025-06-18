import rust
import codeql.rust.Diagnostics

query predicate attribute_macros(Item i, int index, Item expanded) {
  i.fromSource() and expanded = i.getAttributeMacroExpansion().getItem(index)
}

query predicate macro_calls(MacroCall c, AstNode expansion) {
  c.fromSource() and
  not c.getLocation().getFile().getAbsolutePath().matches("%proc_macro.rs") and
  expansion = c.getMacroCallExpansion()
}

query predicate unexpanded_macro_calls(MacroCall c) {
  c.fromSource() and not c.hasMacroCallExpansion()
}

query predicate warnings(ExtractionWarning w) { any() }
