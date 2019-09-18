import semmle.code.csharp.Conversion

// Avoid printing conversions for type parameters from library
class LibraryTypeParameter extends TypeParameter {
  LibraryTypeParameter() { fromLibrary() }

  override string toString() { none() }
}

class InterestingType extends Type {
  InterestingType() {
    this.fromSource() or
    this instanceof CharType or
    this instanceof BoolType or
    this instanceof IntType or
    this.(NullableType).getUnderlyingType() instanceof IntType
  }
}

from InterestingType sub, Type sup
where
  convBoxing(sub, sup) and
  sub != sup
select sub.toString() as s1, sup.toString() as s2 order by s1, s2
