import cpp

from Stmt s, boolean pure, boolean pureExceptLocals
where
  (if s.isPure() then pure = true else pure = false) and
  if s.mayBeGloballyImpure() then pureExceptLocals = false else pureExceptLocals = true
select s, pure, pureExceptLocals
