import csharp
import semmle.code.csharp.commons.QualifiedName

from
  Method m, Method overrider, string mnamespace, string mtype, string mname, string onamespace,
  string otype, string oname
where
  m.getAnOverrider() = overrider and
  m.getFile().getStem() = "CovariantReturn" and
  m.hasFullyQualifiedName(mnamespace, mtype, mname) and
  overrider.hasFullyQualifiedName(onamespace, otype, oname)
select getQualifiedName(mnamespace, mtype, mname), m.getReturnType().toString(),
  getQualifiedName(onamespace, otype, oname), overrider.getReturnType().toString()
