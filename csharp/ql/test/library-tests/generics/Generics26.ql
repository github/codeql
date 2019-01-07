import csharp

// Source declaration and unbound generic must be unique
where
  not exists(ConstructedGeneric cg |
    strictcount(cg.getSourceDeclaration+()) > 1 or
    strictcount(cg.getUnboundGeneric()) > 1
  )
select "Test passed"
