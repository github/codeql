import csharp

from Attributable element, Attribute attribute
where attribute = element.getAnAttribute()
select element, attribute, attribute.getType().getQualifiedName()
