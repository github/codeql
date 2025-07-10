/**
 * Provides a module for renumbering MaD IDs in data flow path explanations in
 * order to produce more stable test output.
 *
 * In addition to the `PathGraph`, a `query predicate models` is provided to
 * list the contents of the referenced MaD rows.
 */

private import codeql.dataflow.DataFlow as DF

signature predicate interpretModelForTestSig(QlBuiltins::ExtensionId madId, string model);

signature class PathNodeSig {
  string toString();
}

private signature predicate provenanceSig(string model);

/** Translates models-as-data provenance information into a format that can be used in tests. */
module TranslateModels<
  interpretModelForTestSig/2 interpretModelForTest0, provenanceSig/1 provenance>
{
  private predicate madIds(string madId) {
    exists(string model |
      provenance(model) and
      model.regexpFind("(?<=MaD:)[0-9]*", _, _) = madId
    )
  }

  // Be robust against MaD IDs with multiple textual representations; simply
  // concatenate them all
  private predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model) {
    model = strictconcat(string mod | interpretModelForTest0(madId, mod) | mod, ", ")
  }

  private QlBuiltins::ExtensionId getModelId(string model) {
    madIds(result.toString()) and
    interpretModelForTest(result, model)
  }

  // collapse models with the same textual representation, in order to not rely
  // on the order of `ExtensionId`s
  private module ExtensionIdSets =
    QlBuiltins::InternSets<string, QlBuiltins::ExtensionId, getModelId/1>;

  private predicate rankedMadIds(ExtensionIdSets::Set extIdSet, int r) {
    extIdSet =
      rank[r](ExtensionIdSets::Set extIdSet0, string model |
        extIdSet0 = ExtensionIdSets::getSet(model)
      |
        extIdSet0 order by model
      )
  }

  private predicate translateModel(string id, int r) {
    exists(QlBuiltins::ExtensionId madId, ExtensionIdSets::Set extIdSet |
      id = madId.toString() and
      extIdSet.contains(madId) and
      rankedMadIds(extIdSet, r)
    )
  }

  /** Lists the renumbered and pretty-printed models used in the edges relation. */
  predicate models(int r, string model) {
    exists(string madId | translateModel(madId, r) and getModelId(model).toString() = madId)
  }

  private predicate translateModelsPart(string model1, string model2, int i) {
    provenance(model1) and
    exists(string s | model1.splitAt("MaD:", i) = s |
      model2 = s and i = 0
      or
      exists(string part, string madId, string rest, int r |
        translateModelsPart(model1, part, i - 1) and
        madId = s.regexpCapture("([0-9]*)(.*)", 1) and
        rest = s.regexpCapture("([0-9]*)(.*)", 2) and
        translateModel(madId, r) and
        model2 = part + "MaD:" + r + rest
      )
    )
  }

  /** Holds if the model `model1` should be translated to `model2`. */
  predicate translateModels(string model1, string model2) {
    exists(int i |
      translateModelsPart(model1, model2, i) and
      not translateModelsPart(model1, _, i + 1)
    )
  }
}

/** Transforms a `PathGraph` by printing the provenance information. */
module ShowProvenance<
  interpretModelForTestSig/2 interpretModelForTest, PathNodeSig PathNode,
  DF::PathGraphSig<PathNode> PathGraph> implements DF::PathGraphSig<PathNode>
{
  private predicate provenance(string model) { PathGraph::edges(_, _, _, model) }

  private module Models = TranslateModels<interpretModelForTest/2, provenance/1>;

  additional query predicate models(int r, string model) { Models::models(r, model) }

  query predicate edges(PathNode a, PathNode b, string key, string val) {
    exists(string model |
      PathGraph::edges(a, b, key, model) and
      Models::translateModels(model, val)
    )
  }

  query predicate nodes = PathGraph::nodes/3;

  query predicate subpaths = PathGraph::subpaths/4;
}

/**
 * Provides logic for creating a `@kind test-postprocess` query that prints
 * the provenance information.
 */
module TestPostProcessing {
  external predicate queryResults(string relation, int row, int column, string data);

  external predicate queryRelations(string relation);

  /** Transforms a `PathGraph` by printing the provenance information. */
  module TranslateProvenanceResults<interpretModelForTestSig/2 interpretModelForTest> {
    private int provenanceColumn() { result = 5 }

    private predicate provenance(string model) {
      queryResults("edges", _, provenanceColumn(), model)
    }

    private module Models = TranslateModels<interpretModelForTest/2, provenance/1>;

    query predicate results(string relation, int row, int column, string data) {
      queryResults(relation, row, column, data) and
      (relation != "edges" or column != provenanceColumn())
      or
      exists(string model |
        relation = "edges" and
        column = provenanceColumn() and
        queryResults(relation, row, column, model) and
        Models::translateModels(model, data)
      )
      or
      exists(string model |
        relation = "models" and
        Models::models(row, model)
      |
        column = 0 and data = row.toString()
        or
        column = 1 and data = model
      )
    }

    query predicate resultRelations(string relation) { queryRelations(relation) }
  }
}
