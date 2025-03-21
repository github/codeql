private import codeql.dataflow.DataFlow as DF
private import codeql.dataflow.test.ProvenancePathGraph as Graph
private import codeql.rust.dataflow.internal.ModelsAsData

/** Transforms a `PathGraph` by printing the provenance information. */
module ShowProvenance<Graph::PathNodeSig PathNode, DF::PathGraphSig<PathNode> PathGraph> {
  import Graph::ShowProvenance<interpretModelForTest/2, PathNode, PathGraph>
}
