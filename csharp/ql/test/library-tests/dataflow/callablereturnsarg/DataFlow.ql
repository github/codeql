import csharp
import Common

from Configuration c, Parameter p, int outRefArg
where
  flowOutFromParameter(c, p) and outRefArg = -1
  or
  flowOutFromParameterOutOrRef(c, p, outRefArg)
select p.getCallable(), p.getPosition(), outRefArg
