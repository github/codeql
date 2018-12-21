import dotnet
import semmle.code.csharp.commons.Disposal
import Whitelist

from DotNet::Callable c, DotNet::Parameter param, int p
where
  mayBeDisposed(param) and
  param = c.getParameter(p) and
  not whitelistedType(c.getDeclaringType())
select c.toStringWithTypes(), p
