import csharp
import semmle.code.csharp.frameworks.System
import semmle.code.csharp.frameworks.system.Collections
import semmle.code.csharp.frameworks.system.collections.Generic

predicate implementsMethod(Method m, int i) {
  exists(Method other, Method imp |
    m.overridesOrImplementsOrEquals(imp) and
    other = imp.getSourceDeclaration()
  |
    other = any(SystemObjectClass c).getEqualsMethod() and i = 1
    or
    other = any(SystemObjectClass c).getStaticEqualsMethod() and i = 2
    or
    other = any(SystemObjectClass c).getReferenceEqualsMethod() and i = 3
    or
    other = any(SystemObjectClass c).getGetHashCodeMethod() and i = 4
    or
    other = any(SystemIEquatableTInterface iface).getEqualsMethod() and i = 5
    or
    other = any(SystemCollectionsIComparerInterface iface).getCompareMethod() and i = 6
    or
    other = any(SystemCollectionsGenericIComparerTInterface iface).getCompareMethod() and i = 7
    or
    other = any(SystemIComparableInterface iface).getCompareToMethod() and i = 8
    or
    other = any(SystemIComparableTInterface iface).getCompareToMethod() and i = 9
  )
}

from Element e, int i
where
  e.getFile().getStem() = "System" and
  e.fromSource() and
  (
    implementsMethod(e, i)
    or
    implementsMethod(e.(MethodCall).getTarget(), i)
  )
select e, i
