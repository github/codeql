import csharp

from Ssa::SourceVariable v, Ssa::PhiNode phi, SsaDefinition input
where
  phi.getAnInput() = input and
  v = phi.getSourceVariable()
select v, phi, input
