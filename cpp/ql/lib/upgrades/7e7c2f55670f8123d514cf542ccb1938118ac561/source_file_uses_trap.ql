newtype TSourceFile = MkSourceFile()

module FreshSourceFile = QlBuiltins::NewEntity<TSourceFile>;

class SourceFile extends FreshSourceFile::EntityId {
  string toString() { none() }
}

class Trap extends @trap {
  string toString() { none() }
}

from SourceFile source_file, Trap trap
where none()
select source_file, trap
