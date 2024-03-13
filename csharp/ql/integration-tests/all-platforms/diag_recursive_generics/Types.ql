import csharp
import semmle.code.csharp.commons.QualifiedName

from Class c, string qualifier, string name
where c.fromSource() and c.getBaseClass().hasFullyQualifiedName(qualifier, name)
select c, getQualifiedName(qualifier, name)
