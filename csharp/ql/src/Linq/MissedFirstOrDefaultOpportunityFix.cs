using System;
using System.Collections.Generic;
using System.Linq;

class MissedFirstOrDefaultOpportunityFix
{
    public static Operation FindOperation(IEnumerable<Operation> operations, string operationId)
    {
        return operations.FirstOrDefault(operation =>
            string.Equals(operation.OperationId, operationId, StringComparison.Ordinal));
    }
}
