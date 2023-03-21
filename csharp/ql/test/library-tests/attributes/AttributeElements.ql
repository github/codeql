import csharp
import semmle.code.csharp.commons.QualifiedName

from Attributable element, Attribute attribute, string qualifier, string name
where
  attribute = element.getAnAttribute() and
  (attribute.fromSource() or element.(Assembly).getName() in ["attributes", "Assembly1"]) and
  attribute.getType().hasQualifiedName(qualifier, name)
select element, attribute, getQualifiedName(qualifier, name)
