# Unvalidated local pointer arithmetic

```
ID: cs/unvalidated-local-pointer-arithmetic
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-119 external/cwe/cwe-120 external/cwe/cwe-122 external/cwe/cwe-788

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-119/LocalUnvalidatedArithmetic.ql)

It is dangerous to use the result of a virtual method call in pointer arithmetic without validation if external users can provide their own implementation of the virtual method. For example, if the analyzed project is distributed as a library or framework, then the end-user could provide a new implementation that returns any value.


## Recommendation
Always validate the result of virtual methods calls before performing pointer arithmetic to avoid reading or writing outside the bounds of an allocated buffer.


## Example
In this example, we write to a given element of an array, using an instance of the `PossiblyOverridableClass` to determine which element to write to.

In the first case, the `GetElementNumber` method is called, and the result is used in pointer arithmetic without any validation. If the user can define a subtype of `PossiblyOverridableClass`, they can create an implementation of `GetElementNumber` that returns an invalid element number. This would lead to a write occurring outside the bounds of the `charArray`.

In the second case, the result of `GetElementNumber` is stored, and confirmed to be within the bounds of the array. Note that it is not sufficient to check that it is smaller than the length. We must also ensure that it's greater than zero, to prevent writes to locations before the buffer as well as afterwards.


```csharp
public class PossiblyOverridable
{
    public virtual int GetElementNumber()
    {
        // By default returns 0, which is safe
        return 0;
    }
}

public class PointerArithmetic
{
    public unsafe void WriteToOffset(PossiblyOverridable possiblyOverridable,
                                     char[] charArray)
    {
        fixed (char* charPointer = charArray)
        {
            // BAD: Unvalidated use of virtual method call result in pointer arithmetic
            char* newCharPointer = charPointer + possiblyOverridable.GetElementNumber();
            *newCharPointer = 'A';
            // GOOD: Check that the number is viable
            int number = possiblyOverridable.GetElementNumber();
            if (number >= 0 && number < charArray.Length)
            {
                char* newCharPointer2 = charPointer + number;
                *newCharPointer = 'A';
            }
        }
    }
}

```

## References
* Microsoft: [Unsafe Code and Pointers](https://msdn.microsoft.com/en-us/library/t2yzs44b.aspx).
* Common Weakness Enumeration: [CWE-119](https://cwe.mitre.org/data/definitions/119.html).
* Common Weakness Enumeration: [CWE-120](https://cwe.mitre.org/data/definitions/120.html).
* Common Weakness Enumeration: [CWE-122](https://cwe.mitre.org/data/definitions/122.html).
* Common Weakness Enumeration: [CWE-788](https://cwe.mitre.org/data/definitions/788.html).