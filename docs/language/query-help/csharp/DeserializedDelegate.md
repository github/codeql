# Deserialized delegate

```
ID: cs/deserialized-delegate
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-502

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-502/DeserializedDelegate.ql)

Deserializing a delegate object may result in remote code execution, when an attacker can control the serialized data.


## Recommendation
Avoid deserializing delegate objects, if possible, or make sure that the serialized data cannot be controlled by an attacker.


## Example
In this example, a file stream is deserialized to a `Func<int>` object, using a `BinaryFormatter`. The file stream is a parameter of a public method, so depending on the calls to `InvokeSerialized`, this may or may not pose a security problem.


```csharp
using System;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

class Bad
{
    public static int InvokeSerialized(FileStream fs)
    {
        var formatter = new BinaryFormatter();
        // BAD
        var f = (Func<int>)formatter.Deserialize(fs);
        return f();
    }
}

```

## References
* Microsoft: [BinaryFormatter Class](https://docs.microsoft.com/en-us/dotnet/api/system.runtime.serialization.formatters.binary.binaryformatter).
* Common Weakness Enumeration: [CWE-502](https://cwe.mitre.org/data/definitions/502.html).