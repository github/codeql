import csharp

from Attributable element, Attribute attribute
where
  attribute = element.getAnAttribute() and
  (attribute.fromSource() or element.(Assembly).getName() in ["attributes", "Assembly1"])
select element, attribute, attribute.getType().getQualifiedName()
