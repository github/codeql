import rust
import codeql.rust.Diagnostics

query predicate warnings(ExtractionWarning w) { w.getLocation().fromSource() }
