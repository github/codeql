import codeql.rust.dataflow.internal.ModelsAsData
import codeql.rust.dataflow.internal.TaintTrackingImpl
import codeql.files.FileSystem

/*
 * Note: madId columns are ignored, since renaming extension files causes them to be loaded in a
 * different order, and the generated values in that column do not match as a result.
 */

query predicate additionalExternalFiles(string relativePath) {
  additionalExternalFile(relativePath)
}

query predicate excludeFieldTaintSteps(string field) { excludeFieldTaintStep(field) }

query predicate sourceModels(string path, string output, string kind, string provenance) {
  sourceModel(path, output, kind, provenance, _)
}

query predicate sinkModels(string path, string input, string kind, string provenance) {
  sinkModel(path, input, kind, provenance, _)
}

query predicate summaryModels(
  string path, string input, string output, string kind, string provenance
) {
  summaryModel(path, input, output, kind, provenance, _)
}

query predicate neutralModels(string path, string kind, string provenance) {
  neutralModel(path, kind, provenance, _)
}

query predicate barrierModels(string path, string output, string kind, string provenance) {
  barrierModel(path, output, kind, provenance, _)
}

query predicate barrierGuardModels(
  string path, string input, string acceptingValue, string kind, string provenance
) {
  barrierGuardModel(path, input, acceptingValue, kind, provenance, _)
}
