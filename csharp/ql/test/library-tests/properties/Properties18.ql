import csharp

from Property property, Accessor accessor
where
  property.getDeclaringType().hasName("ImplementsProperties") and
  property.getAnAccessor() = accessor
select property, accessor
