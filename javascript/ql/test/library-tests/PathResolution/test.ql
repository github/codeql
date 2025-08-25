import javascript

query predicate importTarget(Import imprt, string value) {
  imprt.getImportedModule().getFile().getRelativePath() = value
}
