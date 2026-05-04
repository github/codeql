import csharp
private import semmle.code.csharp.dataflow.internal.SsaImpl as SsaImpl

from Ssa::SourceVariable v, SsaDefinition def
where
  v = def.getSourceVariable() and
  SsaImpl::isLiveOutRefParameterDefinition(def, _)
select v, def
