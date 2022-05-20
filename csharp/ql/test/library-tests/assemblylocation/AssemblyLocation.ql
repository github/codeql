import csharp

from Element e, Assembly a
where
  e.fromSource() and
  a = e.getALocation() and
  a.getFullName() = "program, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null"
select e
