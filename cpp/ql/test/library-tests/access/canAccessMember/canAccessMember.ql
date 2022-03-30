import cpp

from Function f, Class namingClass, Declaration member
where
  f.canAccessMember(member, namingClass) and
  // only in same namespace
  f.getNamespace() = namingClass.getNamespace() and
  not f.isCompilerGenerated()
select f.getQualifiedName(), "Can access " + namingClass.getName() + "::" + member.getName()
