/**
 * @kind test-postprocess
 */

import semmle.go.dataflow.ExternalFlow
import codeql.dataflow.test.ProvenancePathGraph::TestPostProcessing::TranslateProvenanceResults<interpretModelForTest/2>

from string relation, int row, int column, string data
where results(relation, row, column, data)
select relation, row, column, data
