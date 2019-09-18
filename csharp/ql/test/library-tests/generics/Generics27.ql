import csharp

from ConstructedType ct, UnboundGenericType ugt, UnboundGenericType sourceDecl
where
  ct instanceof NestedType and
  ugt = ct.getUnboundGeneric() and
  sourceDecl = ct.getSourceDeclaration() and
  ugt != sourceDecl
select ct, ugt, sourceDecl
