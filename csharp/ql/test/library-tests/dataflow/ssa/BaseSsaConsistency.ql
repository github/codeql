import csharp
import semmle.code.csharp.dataflow.internal.BaseSSA

from AssignableRead ar, BaseSsa::Definition ssaDef, AssignableDefinition def, LocalScopeVariable v
where
  ar = ssaDef.getARead() and
  def = ssaDef.getDefinition() and
  v = def.getTarget() and
  not exists(Ssa::ExplicitDefinition edef |
    edef.getADefinition() = def and
    edef.getARead() = ar
  )
select ar, def
