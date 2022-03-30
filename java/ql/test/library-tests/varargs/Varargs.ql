import default

from Callable c, Parameter varargparm
where
  varargparm = c.getAParameter() and
  varargparm.isVarargs() and
  (exists(c.getAReference()) or c.fromSource())
select c.getDeclaringType().getQualifiedName(), c.getStringSignature(), varargparm.getName()
