newtype TCompilation = TPlaceHolderCompilation()

module Fresh = QlBuiltins::NewEntity<TCompilation>;

class NewCompilationBase = @compilation or Fresh::EntityId;

class NewCompilation extends NewCompilationBase {
  string toString() { none() }
}

class File extends @file {
  string toString() { none() }
}

query predicate new_compilations(NewCompilation compilation, string cwd) {
  compilations(compilation, cwd)
  or
  compilation = Fresh::map(TPlaceHolderCompilation()) and
  cwd = ""
}

query predicate new_fileannotations(
  File id, NewCompilation compilation, int kind, string name, string value
) {
  fileannotations(id, kind, name, value) and
  compilation = Fresh::map(TPlaceHolderCompilation())
}
