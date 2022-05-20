import csharp
import cil
import dotnet

class MetadataEntity extends DotNet::NamedElement, @metadata_entity {
  int getHandle() { metadata_handle(this, _, result) }

  predicate hasHandle() { exists(this.getHandle()) }

  Assembly getAssembly() { metadata_handle(this, result, _) }
}

query predicate tooManyHandles(string s) {
  exists(MetadataEntity e, Assembly a |
    strictcount(int handle | metadata_handle(e, a, handle)) > 1 and
    s = e.getQualifiedName()
  )
}

private class UniqueMetadataEntity extends MetadataEntity {
  UniqueMetadataEntity() {
    // Tuple types such as `(,)` and `ValueTuple`2` share the same handle
    not this instanceof TupleType and
    not this.getQualifiedName().matches("System.ValueTuple%")
  }
}

query predicate tooManyMatchingHandles(string s) {
  exists(UniqueMetadataEntity e, Assembly a, int handle |
    metadata_handle(e, a, handle) and
    strictcount(UniqueMetadataEntity e2 | metadata_handle(e2, a, handle)) > 2 and
    s = e.getQualifiedName()
  )
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

query predicate csharpLocationViolation(Element e) {
  e.fromLibrary() and
  e.(MetadataEntity).hasHandle() and
  not e.getALocation() = e.(MetadataEntity).getAssembly()
}

query predicate matchingObjectMethods(string s1, string s2) {
  exists(Callable m1, CIL::Method m2 |
    m1.getDeclaringType().getQualifiedName() = "System.Object" and
    m1.matchesHandle(m2) and
    s1 = m1.toStringWithTypes() and
    s2 = m2.toStringWithTypes()
  )
}
