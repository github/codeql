import java

from ClassOrInterface ci, Member m
where m = ci.getAMember() and ci.getSourceDeclaration().fromSource()
select ci, m

query predicate enclosingTypes(NestedType nt, Type encl) {
  nt.getSourceDeclaration().fromSource() and encl = nt.getEnclosingType()
}
