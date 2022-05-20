import csharp

from Method m, ExplicitDelegateCreation e
where
  m.hasName("MainDelegateAndMethodAccesses") and
  e.getEnclosingCallable() = m and
  e.getDelegateType().hasName("D") and
  e.getArgument().(LocalFunctionAccess).getTarget().hasName("LocalFunction")
select m, e
