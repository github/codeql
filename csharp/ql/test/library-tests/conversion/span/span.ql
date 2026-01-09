import semmle.code.csharp.Conversion

private class InterestingType extends Type {
  InterestingType() { exists(LocalVariable lv | lv.getType() = this) }
}

from InterestingType sub, InterestingType sup
where convSpan(sub, sup) and sub != sup
select sub.toStringWithTypes() as s1, sup.toStringWithTypes() as s2 order by s1, s2
