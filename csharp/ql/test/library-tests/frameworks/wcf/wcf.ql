import semmle.code.csharp.frameworks.WCF

from OperationMethod om, DataContractClass dcc
where om.getAParameter().getType() = dcc
select om, dcc, dcc.getADataMember()
