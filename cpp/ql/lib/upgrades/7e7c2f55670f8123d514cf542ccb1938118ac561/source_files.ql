newtype TSourceFile = MkSourceFile(string name) { source_file_uses_trap(name, _) }

module FreshSourceFile = QlBuiltins::NewEntity<TSourceFile>;

class SourceFile extends FreshSourceFile::EntityId {
  string toString() { none() }
}

class Trap extends @trap {
  string toString() { none() }
}

query predicate mk_source_file_name(SourceFile source_file, string name) {
  source_file = FreshSourceFile::map(MkSourceFile(name))
}

query predicate mk_source_file_uses_trap(SourceFile source_file, Trap trap) {
  exists(string name |
    source_file_uses_trap(name, trap) and
    mk_source_file_name(source_file, name)
  )
}
