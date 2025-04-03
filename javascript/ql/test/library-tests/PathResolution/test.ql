import javascript
import semmle.javascript.internal.PathResolution

query predicate importTarget(Import imprt, string value) {
  imprt.getImportedModule().getFile().getRelativePath() = value
}
