using System;
using System.Collections.Generic;

class MissedFirstOrDefaultOpportunityGood
{
    public static Operation FindOperationOrThrow(IEnumerable<Operation> operations, string operationId)
    {
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, StringComparison.Ordinal))
                throw new InvalidOperationException("Unexpected operation.");
        }

        return null;
    }

    public static Operation FindReplacementOperation(IEnumerable<Operation> operations, string operationId)
    {
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, StringComparison.Ordinal))
                return operation;
        }

        return new Operation();
    }

    public static string FindOperationId(IEnumerable<Operation> operations, string operationId)
    {
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, StringComparison.Ordinal))
                return operation.OperationId;
        }

        return null;
    }
}
