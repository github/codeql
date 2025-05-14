import go

from IR::ExtractTupleElementInstruction extract, IR::Instruction base, int idx, Type resultType
where extract.extractsElement(base, idx) and resultType = extract.getResultType()
select extract, base, idx, resultType
