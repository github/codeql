import dotnet
import semmle.code.csharp.commons.Disposal
import cil

from DotNet::Callable c, DotNet::Parameter param, int p
where
  not mayBeDisposed(param) and
  param = c.getParameter(p) and
  c.getDeclaringType().getQualifiedName() = "DisposalTests.Class1"
select c.toStringWithTypes(), p
