import python

from string txt, Value val
where
  exists(string s |
    txt = "u'" + s + "'" and val = Value::forUnicode(s)
    or
    txt = "b'" + s + "'" and val = Value::forBytes(s)
  |
    s in ["a", "b", "c", "d"]
  )
  or
  exists(int i | txt = i.toString() and val = Value::forInt(i) |
    i in [1 .. 10] or i in [1000 .. 1010]
  )
select txt, val
