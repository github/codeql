import csharp
import semmle.code.csharp.dataflow.ExternalFlow

query predicate awsRemoteSources(DataFlow::ExprNode node) { sourceNode(node, "remote") }
