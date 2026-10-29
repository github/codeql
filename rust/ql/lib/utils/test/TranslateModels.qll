private import codeql.dataflow.test.ProvenancePathGraph as Graph
private import codeql.rust.dataflow.internal.ModelsAsData as MaD

private signature predicate provenanceSig(string model);

/** Translates models-as-data provenance information into a format that can be used in tests. */
module TranslateModels<provenanceSig/1 provenance> {
  import Graph::TranslateModels<MaD::interpretModelForTest/2, provenance/1>
}
