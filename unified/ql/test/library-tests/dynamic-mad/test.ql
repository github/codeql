private import unified
private import codeql.unified.internal.mad.DynamicMaD as DynamicMaD

query predicate isSource(DataFlow::Node node, string kind) { DynamicMaD::sourceNode(node, kind, _) }

query predicate isSink(DataFlow::Node node, string kind) { DynamicMaD::sinkNode(node, kind, _) }
