class SourceFile extends @source_file {
  string toString() { none() }
}

class Trap extends @trap {
  string toString() { none() }
}

from SourceFile source_file, string name, Trap trap
where source_file_uses_trap(source_file, trap)
  and source_file_name(source_file, name)
select name, trap
