/**
 * @kind test-postprocess
 */

import semmle.code.csharp.dataflow.internal.ExternalFlow
import codeql.dataflow.test.ProvenancePathGraph
import codeql.dataflow.test.ProvenancePathGraph::TestPostProcessing::TranslateProvenanceResults<interpretModelForTest/2>

from string relation, int row, int column, string data
where results(relation, row, column, data)
select relation, row, column, data
