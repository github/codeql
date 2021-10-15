import cpp

from Expr e, string pure, string impure, string globalimpure
where
  (if e.isPure() then pure = "isPure" else pure = "") and
  (if e.mayBeImpure() then impure = "mayBeImpure" else impure = "") and
  if e.mayBeGloballyImpure() then globalimpure = "mayBeGloballyImpure" else globalimpure = ""
select e, pure, impure, globalimpure
