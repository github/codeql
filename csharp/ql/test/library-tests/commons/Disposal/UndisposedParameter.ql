import dotnet
import semmle.code.csharp.commons.Disposal
import cil

from DotNet::Callable c, DotNet::Parameter param, int p
where
  not mayBeDisposed(param) and
  param.getType().hasName("TextWriter") and
  param = c.getParameter(p)
select c.toStringWithTypes(), p
