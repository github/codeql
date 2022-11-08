import csharp

from Attributable element, Attribute attribute, string qualifier, string name
where
  attribute = element.getAnAttribute() and
  (attribute.fromSource() or element.(Assembly).getName() in ["attributes", "Assembly1"]) and
  attribute.getType().hasQualifiedName(qualifier, name)
select element, attribute, printQualifiedName(qualifier, name)
