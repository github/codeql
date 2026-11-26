import python

from string k, string v
where
  k.startsWith("options.") and
  not k.startsWith("options.verbos") and
  py_flags_versioned(k, v, _)
select k, v
