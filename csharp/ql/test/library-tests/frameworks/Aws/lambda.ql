import csharp
import semmle.code.csharp.dataflow.internal.ExternalFlow

query predicate awsRemoteSources(DataFlow::ExprNode node) { sourceNode(node, "remote") }

query predicate awsLoggingSinks(DataFlow::ExprNode node) { sinkNode(node, "log-injection") }
