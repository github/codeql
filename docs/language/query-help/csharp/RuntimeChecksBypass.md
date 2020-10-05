# Serialization check bypass

```
ID: cs/serialization-check-bypass
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-20

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-020/RuntimeChecksBypass.ql)

Fields that are deserialized should be validated, otherwise the deserialized object could contain invalid data.

This query finds cases where a field is validated in a constructor, but not in a deserialization method. This is an indication that the deserialization method is missing a validation step.


## Recommendation
If a field needs to be validated, then ensure that validation is also performed during deserialization.


## Example
The following example has the validation of the `Age` field in the constructor but not in the deserialization method:


```csharp
using System;
using System.Runtime.Serialization;

[Serializable]
public class PersonBad : ISerializable
{
    public int Age;

    public PersonBad(int age)
    {
        if (age < 0)
            throw new ArgumentException(nameof(age));
        Age = age;
    }

    [OnDeserializing]
    void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
    {
        Age = info.GetInt32("age");  // BAD - write is unsafe
    }
}

```
The problem is fixed by adding validation to the deserialization method as follows:


```csharp
using System;
using System.Runtime.Serialization;

[Serializable]
public class PersonGood : ISerializable
{
    public int Age;

    public PersonGood(int age)
    {
        if (age < 0)
            throw new ArgumentException(nameof(age));
        Age = age;
    }

    [OnDeserializing]
    void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
    {
        int age = info.GetInt32("age");
        if (age < 0)
            throw new SerializationException(nameof(Age));
        Age = age;  // GOOD - write is safe
    }
}

```

## References
* OWASP: [Data Validation](https://www.owasp.org/index.php/Data_Validation).
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).