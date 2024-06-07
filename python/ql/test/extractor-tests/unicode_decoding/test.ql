import python

from Object o, string s
where
  py_cobjectnames(o, s) and
  count(string s1 | py_cobjectnames(o, s1)) > 1
select o, s
