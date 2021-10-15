import javascript

query predicate test_moduleMember(string path, string m, DataFlow::SourceNode res) {
  res = DataFlow::moduleMember(path, m)
}
