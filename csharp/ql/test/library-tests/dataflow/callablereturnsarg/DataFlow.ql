import csharp
import Common

from Parameter p, int outRefArg
where
  Data::flowOutFromParameter(p) and outRefArg = -1
  or
  Data::flowOutFromParameterOutOrRef(p, outRefArg)
select p.getCallable(), p.getPosition(), outRefArg
