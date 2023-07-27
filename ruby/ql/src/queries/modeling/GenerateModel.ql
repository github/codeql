// TODO: metadata
private import internal.Types
private import internal.Sinks

query predicate typeModel = Types::typeModel/3;

query predicate sourceModel(string type, string path, string kind) { none() }

query predicate sinkModel = Sinks::sinkModel/3;

query predicate summaryModel(string type1, string type2, string path) { none() }

query predicate typeVariableModel(string name, string path) { none() }
