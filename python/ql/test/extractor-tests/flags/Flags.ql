import python

from string k, string v
where
  not k.matches("options.%") and
  not k.matches("options.verbos%") and
  py_flags_versioned(k, v, _)
select k, v
