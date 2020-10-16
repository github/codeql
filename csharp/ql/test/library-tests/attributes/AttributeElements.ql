import csharp

from Attributable element, Attribute attribute
where
  attribute = element.getAnAttribute() and
  (element.(Element).fromSource() or element instanceof Assembly)
select element, attribute, attribute.getType().getQualifiedName()
