import semmle.code.csharp.Conversion

from Type sub, Type sup
where
  convNumeric(sub, sup) and
  sub != sup
select sub.toString() as s1, sup.toString() as s2 order by s1, s2
