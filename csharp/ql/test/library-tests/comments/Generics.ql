import csharp

from CommentBlock b, Element e, string s
where
  b.getElement() = e and
  (
    e instanceof ConstructedMethod or
    e instanceof ConstructedClass or
    e instanceof UnboundGenericClass or
    e instanceof UnboundGenericMethod
  ) and
  s = e.getAQlClass() and
  not s = "SourceDeclarationType" and
  not s = "SourceDeclarationCallable" and
  not s = "SourceDeclarationMethod" and
  not s = "NonConstructedMethod" and
  not s = "RuntimeInstanceMethod"
select b, e, s
