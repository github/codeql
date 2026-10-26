import csharp
import semmle.code.csharp.commons.QualifiedName

from Overridable v1, Overridable v2, string kind
where
  (
    v1.getOverridee() = v2 and kind = "overrides"
    or
    v1.getImplementee() = v2 and kind = "implements"
  ) and
  v1.fromSource() and
  v2.fromSource()
select getFullyQualifiedNameWithTypes(v1), getFullyQualifiedNameWithTypes(v2), kind
