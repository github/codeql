using System;
using System.Collections.Generic;
using System.Threading.Tasks;

class MissedFirstOrDefaultOpportunity
{
    public Operation M1(IEnumerable<Operation> operations, string operationId)
    {
        // BAD: Can be replaced with operations.FirstOrDefault(operation => ...).
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, StringComparison.Ordinal))
                return operation;
        } // $ Alert

        return null;
    }

    public int M2(IEnumerable<int> values)
    {
        // BAD: Can be replaced with values.FirstOrDefault(value => ...).
        foreach (var value in values)
        {
            if (value > 0)
            {
                return value;
            }
        } // $ Alert

        return default;
    }

    public int? M3(List<int> values)
    {
        // BAD: Can be replaced with values.FirstOrDefault(value => ...).
        foreach (var value in values)
        {
            if (value > 0)
                return value;
        } // $ Alert

        return default(int);
    }

    public Operation M4(IEnumerable<Operation> operations, string operationId)
    {
        // GOOD: FirstOrDefault does not throw when a match is found.
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, StringComparison.Ordinal))
                throw new InvalidOperationException();
        }

        return null;
    }

    public Operation M5(IEnumerable<Operation> operations, string operationId)
    {
        // GOOD: FirstOrDefault would return null/default when no match is found.
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, StringComparison.Ordinal))
                return operation;
        }

        return new Operation();
    }

    public string M6(IEnumerable<Operation> operations, string operationId)
    {
        // GOOD: FirstOrDefault would return the matching operation, not one of its properties.
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, StringComparison.Ordinal))
                return operation.OperationId;
        }

        return null;
    }

    public Operation M7(IEnumerable<Operation> operations, string operationId)
    {
        // GOOD: The matched case has an additional side effect.
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, StringComparison.Ordinal))
            {
                Console.WriteLine(operation.OperationId);
                return operation;
            }
        }

        return null;
    }

    public async Task<Operation> M8(IEnumerable<Operation> operations, string operationId)
    {
        // GOOD: FirstOrDefault does not support an async predicate.
        foreach (var operation in operations)
        {
            if (await IsMatch(operation, operationId))
                return operation;
        }

        return null;
    }

    public Operation M9(IEnumerable<Operation> operations, string operationId)
    {
        // GOOD: FirstOrDefault does not have an equivalent for an else branch in the loop.
        foreach (var operation in operations)
        {
            if (string.Equals(operation.OperationId, operationId, StringComparison.Ordinal))
                return operation;
            else
                return null;
        }

        return null;
    }

    public object M10(IEnumerable<int> values)
    {
        // GOOD: FirstOrDefault would return boxed 0 when no match is found, not null.
        foreach (var value in values)
        {
            if (value > 0)
                return value;
        }

        return null;
    }

    public object M11(IEnumerable<int> values)
    {
        // GOOD: FirstOrDefault would return boxed 0 when no match is found, not default(object).
        foreach (var value in values)
        {
            if (value > 0)
                return value;
        }

        return default(object);
    }

    public object M12(IEnumerable<string> values)
    {
        // BAD: FirstOrDefault returns null for missing reference-type elements, matching the fallback.
        foreach (var value in values)
        {
            if (value.Length > 0)
                return value;
        } // $ Alert

        return null;
    }

    public object M13(IEnumerable<int> values)
    {
        // BAD: FirstOrDefault returns 0 for missing int elements, matching the fallback before boxing.
        foreach (var value in values)
        {
            if (value > 0)
                return value;
        } // $ Alert

        return default(int);
    }

    public Operation M14(IEnumerable<Operation> operations, Func<string, bool>[] predicates)
    {
        // GOOD: Ignore the corner case where the foreach variable is captured by a nested lambda.
        foreach (var operation in operations)
        {
            if (Array.Exists(predicates, predicate => predicate(operation.OperationId)))
                return operation;
        }

        return null;
    }

    private static Task<bool> IsMatch(Operation operation, string operationId) =>
        Task.FromResult(string.Equals(operation.OperationId, operationId, StringComparison.Ordinal));
}

class Operation
{
    public string OperationId { get; set; }
}
