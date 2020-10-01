import python

from Object o, string name
where
  o.hasLongName(name) and
  (
    name = "sys.modules"
    or
    name = "test.n"
    or
    name = "test.l"
    or
    name = "test.d"
    or
    name = "test.C.meth"
    or
    name = "test.C.cmeth"
    or
    name = "test.C.smeth"
  )
select name, o.toString()
