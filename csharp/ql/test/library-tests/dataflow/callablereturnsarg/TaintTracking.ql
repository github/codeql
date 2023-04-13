import csharp
import Common

from Parameter p, int outRefArg
where
  Taint::flowOutFromParameter(p) and outRefArg = -1
  or
  Taint::flowOutFromParameterOutOrRef(p, outRefArg)
select p.getCallable(), p.getPosition(), outRefArg
