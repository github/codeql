import csharp
import semmle.code.csharp.dataflow.internal.BaseSSA

from AssignableRead ar, AssignableDefinition def, LocalScopeVariable v
where
  ar = BaseSsa::getARead(def, v) and
  not exists(Ssa::ExplicitDefinition edef |
    edef.getADefinition() = def and
    edef.getARead() = ar
  )
select ar, def
