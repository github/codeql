/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.security.CommandInjectionQuery
import codeql.dataflow.test.ProvenancePathGraph
import codeql.ruby.frameworks.data.internal.ApiGraphModels
import ShowProvenance<interpretModelForTest/2, CommandInjectionFlow::PathNode, CommandInjectionFlow::PathGraph>

from CommandInjectionFlow::PathNode source, CommandInjectionFlow::PathNode sink, Source sourceNode
where
  CommandInjectionFlow::flowPath(source, sink) and
  sourceNode = source.getNode()
select sink.getNode(), source, sink, "This command depends on a $@.", sourceNode,
  sourceNode.getSourceType()
