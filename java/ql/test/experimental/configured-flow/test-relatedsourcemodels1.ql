import semmle.code.java.dataflow.ExternalFlowConfiguration

from string relatedKind, string kind
where kind = "remote" and relatedKind = relatedSourceModel(kind)
select kind, relatedKind
