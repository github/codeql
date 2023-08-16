// TODO: metadata
private import internal.Types
private import internal.Summaries

query predicate typeModel = Types::typeModel/3;

query predicate sourceModel(string type, string path, string kind) { none() }

query predicate sinkModel(string type1, string type2, string path) { none() }

query predicate summaryModel = Summaries::summaryModel/5;

query predicate typeVariableModel(string name, string path) { none() }
