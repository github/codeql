import go

from SsaDefinition ssa, DataFlow::ReadNode read
where read.readsSsaDefinition(ssa)
select read.asInstruction(), ssa, ssa.getSourceVariable()
