class MissedFirstOrDefaultOpportunityFix
{
    public static Operation FindOperation(System.Collections.Generic.IEnumerable<Operation> operations, string operationId)
    {
        return operations.FirstOrDefault(operation =>
            string.Equals(operation.OperationId, operationId, System.StringComparison.Ordinal));
    }
}
