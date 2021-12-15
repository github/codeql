import csharp

from Element e, string s1, string s2
where
  s1 = e.toString() and
  s2 = e.toStringWithTypes() and
  s1 != s2 and
  e.fromSource()
select s1, s2
