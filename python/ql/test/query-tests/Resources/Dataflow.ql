import python
import Resources.FileOpen

from EssaVariable v, EssaDefinition def, string open, string exit
where
  def = v.getDefinition() and
  v.getSourceVariable().getName().charAt(0) = "f" and
  (
    var_is_open(v, _) and open = "open"
    or
    not var_is_open(v, _) and open = "closed"
  ) and
  if BaseFlow::reaches_exit(v) then exit = "exit" else exit = ""
select v.getRepresentation() + " = " + v.getDefinition().getRepresentation(), open, exit
