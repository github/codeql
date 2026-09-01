class MissedFirstOrDefaultOpportunityGood
{
    public static Operation FindOperationOrThrow(System.Collections.Generic.IEnumerable<Operation> operations, string operationId)
    {
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, System.StringComparison.Ordinal))
                throw new System.InvalidOperationException("Unexpected operation.");
        }

        return null;
    }

    public static Operation FindReplacementOperation(System.Collections.Generic.IEnumerable<Operation> operations, string operationId)
    {
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, System.StringComparison.Ordinal))
                return operation;
        }

        return new Operation();
    }

    public static string FindOperationId(System.Collections.Generic.IEnumerable<Operation> operations, string operationId)
    {
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, System.StringComparison.Ordinal))
                return operation.OperationId;
        }

        return null;
    }
}
