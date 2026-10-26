import csharp

from PropertyCall pc, Property p, Accessor target
where
  pc.getProperty() = p and
  pc.getTarget() = target and
  p.fromSource()
select p, pc, target
