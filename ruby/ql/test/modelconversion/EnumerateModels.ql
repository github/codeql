import codeql.ruby.frameworks.data.internal.ApiGraphModelsExtensions

/*
 * Note: madId columns are ignored, since renaming extension files causes them to be loaded in a
 * different order, and the generated values in that column do not match as a result.
 */

query predicate typeModels(string type1, string type2, string path) {
  typeModel(type1, type2, path)
}

query predicate typeVariableModels(string name, string path) { typeVariableModel(name, path) }

query predicate barrierGuardModels(string type, string path, string acceptingValue, string kind) {
  barrierGuardModel(type, path, acceptingValue, kind, _)
}

query predicate barrierModels(string type, string path, string kind) {
  barrierModel(type, path, kind, _)
}

query predicate neutralModels(string type, string path, string kind) {
  neutralModel(type, path, kind)
}

query predicate sinkModels(string type, string path, string kind) { sinkModel(type, path, kind, _) }

query predicate sourceModels(string type, string path, string kind) {
  sourceModel(type, path, kind, _)
}

query predicate summaryModels(string type, string path, string input, string output, string kind) {
  summaryModel(type, path, input, output, kind, _)
}
