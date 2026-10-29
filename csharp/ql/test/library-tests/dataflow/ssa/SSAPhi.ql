import csharp

from Ssa::SourceVariable v, SsaPhiDefinition phi, SsaDefinition input
where
  phi.getAnInput() = input and
  v = phi.getSourceVariable()
select v, phi, input
