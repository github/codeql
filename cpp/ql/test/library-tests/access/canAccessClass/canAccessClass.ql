import cpp

from Function f, Class namingClass, Class base
where
  f.canAccessClass(base, namingClass) and
  // filter out compiler-generated junk
  not namingClass.getNamespace() instanceof GlobalNamespace and
  // only in same namespace
  f.getNamespace() = namingClass.getNamespace() and
  not f.isCompilerGenerated()
select f.getQualifiedName(), "Can convert " + namingClass.getName() + " -> " + base.getName()
