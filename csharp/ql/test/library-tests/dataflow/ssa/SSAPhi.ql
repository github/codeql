import csharp

from Ssa::SourceVariable v, Ssa::PhiNode phi, Ssa::Definition input
where
  phi.getAnInput() = input and
  v = phi.getSourceVariable()
select v, phi, input
