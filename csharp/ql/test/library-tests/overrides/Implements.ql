import csharp

from Virtualizable v1, Virtualizable v2
where
  v1 = v2.getAnUltimateImplementor() and
  v1.fromSource() and
  v2.fromSource()
select v1, v2
