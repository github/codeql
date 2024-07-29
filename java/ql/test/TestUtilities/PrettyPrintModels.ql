/**
 * @kind test-postprocess
 */

import codeql.dataflow.test.ProvenancePathGraph
import semmle.code.java.dataflow.ExternalFlow

external predicate queryResults(string relation, int row, int column, string data);

external predicate queryRelations(string relation);

query predicate resultRelations(string relation) { queryRelations(relation) }

module Res = TranslateProvenanceResults<interpretModelForTest/2, queryResults/4>;

from string relation, int row, int column, string data
where Res::results(relation, row, column, data)
select relation, row, column, data
