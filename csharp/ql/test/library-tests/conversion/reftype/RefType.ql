import semmle.code.csharp.Conversion

// Avoid printing conversions for type parameters from library
class LibraryTypeParameter extends TypeParameter {
  LibraryTypeParameter() { fromLibrary() }

  override string toString() { none() }
}

// Restrict the results
class InterestingType extends Type {
  InterestingType() {
    this.fromSource() or
    this instanceof NullType or
    this instanceof DynamicType or
    this instanceof ObjectType or
    this instanceof IntegralType or
    this.(ConstructedType).getATypeArgument().fromSource() or
    this.(ArrayType).getElementType() instanceof InterestingType
  }
}

from InterestingType sub, InterestingType sup, string s1, string s2
where
  convRefType(sub, sup) and
  sub != sup and
  s1 = sub.toString() and
  s2 = sup.toString() and
  /*
   * Remove certain results to make the test output consistent
   * between different versions of .NET Core.
   */

  s1 != "UInt16[]" and
  s2 != "UInt16[]"
select s1, s2 order by s1, s2
