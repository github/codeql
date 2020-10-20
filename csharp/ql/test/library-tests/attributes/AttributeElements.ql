import csharp

from Attributable element, Attribute attribute
where
  attribute = element.getAnAttribute() and
  (element.(Element).fromSource() or element.(Assembly).getName() = "attributes")
select element, attribute, attribute.getType().getQualifiedName()
