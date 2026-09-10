using System;
using System.Collections.Generic;

class MissedFirstOrDefaultOpportunity
{
    public static Operation FindOperation(IEnumerable<Operation> operations, string operationId)
    {
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, StringComparison.Ordinal))
                return operation;
        }

        return null;
    }
}

class Operation
{
    public string OperationId { get; set; }
}
