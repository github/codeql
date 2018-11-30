import csharp
import cil
import dotnet

class MetadataEntity extends DotNet::NamedElement, @metadata_entity {  
  int getHandle() { metadata_handle(this, _, result) }
  
  predicate hasHandle() { exists(getHandle()) }
  
  Assembly getAssembly() { metadata_handle(this, result, _) }
}

query predicate tooManyMatchingHandles(MetadataEntity e) {
  count(MetadataEntity e2 | e.matchesHandle(e2))>2
}

query predicate missingCil(Element e) {
  (
    e instanceof Callable
    or
    e instanceof Type
    or
    e instanceof Field
  ) and
  e.fromLibrary() and
  e.(MetadataEntity).hasHandle() and
  not exists(CIL::Element ce | ce.(MetadataEntity).matchesHandle(e))
}

query predicate cilLocationViolation(CIL::Element e) {
  e instanceof MetadataEntity
  and
  exists(e.getALocation())
  and
  not e.getALocation() = e.(MetadataEntity).getAssembly()
}

query predicate csharpLocationViolation(Element e) {
  e.fromLibrary() and
  e.(MetadataEntity).hasHandle() and
  not e.getALocation() = e.(MetadataEntity).getAssembly()
}

query predicate matchingObjectMethods(string s1, string s2) {
  exists(Callable m1, CIL::Method m2 |
    m1.getDeclaringType().getQualifiedName() = "System.Object"
    and m1.matchesHandle(m2) and
    s1 = m1.toStringWithTypes() and
    s2 = m2.toStringWithTypes()
  )
}
