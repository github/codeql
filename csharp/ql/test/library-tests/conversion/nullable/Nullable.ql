import semmle.code.csharp.Conversion

class InterestingType extends Type {
  InterestingType() {
    this instanceof IntegralType or
    this instanceof CharType or
    this.(NullableType).getUnderlyingType() instanceof InterestingType
  }
}

from InterestingType sub, Type sup
where
  convNullableType(sub, sup) and
  sub != sup
select sub.toString() as s1, sup.toString() as s2 order by s1, s2
