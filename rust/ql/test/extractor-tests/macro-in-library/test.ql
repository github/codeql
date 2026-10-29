import rust
import codeql.rust.Diagnostics

query predicate macro_items(MacroItems c, int index, Item expanded) {
  exists(c.getFile().getRelativePath()) and
  not c.getLocation().getFile().getAbsolutePath().matches("%proc_macro.rs") and
  expanded = c.getItem(index)
}

query predicate warnings(ExtractionWarning w) { any() }
