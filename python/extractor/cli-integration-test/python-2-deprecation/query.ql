import python
import semmle.python.types.Builtins

predicate named_entity(string name, string kind) {
  exists(Builtin::special(name)) and kind = "special"
  or
  exists(Builtin::builtin(name)) and kind = "builtin"
  or
  exists(Module m | m.getName() = name) and kind = "module"
  or
  exists(File f | f.getShortName() = name + ".py") and kind = "file"
}

from string name
where
  name in ["dircache", "test", "stat"] and
  named_entity(name, "file")
select name order by name
