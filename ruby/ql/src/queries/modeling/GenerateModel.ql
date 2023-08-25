// TODO: metadata
private import internal.Types
private import internal.Sources
private import internal.Sinks
private import internal.Summaries

query predicate typeModel = Types::typeModel/3;

query predicate sourceModel = Sources::sourceModel/3;

query predicate sinkModel = Sinks::sinkModel/3;

query predicate summaryModel = Summaries::summaryModel/5;

query predicate typeVariableModel(string name, string path) { none() }
