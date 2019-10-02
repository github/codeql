import csharp

from CommentBlock b, Element e
where
  b.getElement() = e and
  (
    e instanceof ConstructedMethod or
    e instanceof ConstructedClass or
    e instanceof UnboundGenericClass or
    e instanceof UnboundGenericMethod
  )
select b, e
