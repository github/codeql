import cpp

from Class base, Class derived, AccessSpecifier public
where
  public.hasName("public") and
  // filter out compiler-generated junk
  not derived.getNamespace() instanceof GlobalNamespace
select derived.getQualifiedName(), base.getQualifiedName(),
  derived.accessOfBaseMember(base, public).getName()
