
import python

from string k, string v
where k.prefix(8) = "options." and
not k.prefix(14) = "options.verbos" and
py_flags_versioned(k, v, _)
select k, v

