import python

from Object o, string name
where
  o.hasLongName(name) and
  name in [
      "sys.modules", "test.n", "test.l", "test.d", "test.C.meth", "test.C.cmeth", "test.C.smeth"
    ]
select name, o.toString()
