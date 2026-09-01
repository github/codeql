class MissedFirstOrDefaultOpportunity
{
    public static Operation FindOperation(System.Collections.Generic.IEnumerable<Operation> operations, string operationId)
    {
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, System.StringComparison.Ordinal))
                return operation;
        }

        return null;
    }
}

class Operation
{
    public string OperationId { get; set; }
}
