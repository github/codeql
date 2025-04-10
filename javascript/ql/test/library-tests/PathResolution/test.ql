import javascript
import semmle.javascript.internal.paths.PathExprResolver

query predicate importTarget(Import imprt, string value) {
  imprt.getImportedModule().getFile().getRelativePath() = value
}
