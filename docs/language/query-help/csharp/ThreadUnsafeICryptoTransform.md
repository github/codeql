# Thread-unsafe use of a static ICryptoTransform field

```
ID: cs/thread-unsafe-icryptotransform-field-in-class
Kind: problem
Severity: warning
Precision: medium
Tags: concurrency security external/cwe/cwe-362

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Likely%20Bugs/ThreadUnsafeICryptoTransform.ql)

Classes that implement `System.Security.Cryptography.ICryptoTransform` are not thread safe.

This problem is caused by the way these classes are implemented using Microsoft CAPI/CNG patterns.

For example, when a hash class implements this interface, there would typically be an instance-specific hash object created (for example using `BCryptCreateHash` function). This object can be called multiple times to add data to the hash (for example `BCryptHashData`). Finally, a function is called that finishes the hash and returns the data (for example `BCryptFinishHash`).

Allowing the same hash object to be called with data from multiple threads before calling the finish function could potentially lead to incorrect results.

For example, if you have multiple threads hashing `"abc"` on a static hash object, you may occasionally obtain the results (incorrectly) for hashing `"abcabc"`, or face other unexpected behavior.

It is very unlikely somebody outside Microsoft would write a class that implements `ICryptoTransform`, and even if they do, it is likely that they will follow the same common pattern as the existing classes implementing this interface.

Any object that implements `System.Security.Cryptography.ICryptoTransform` should not be used in concurrent threads as the instance members of such object are also not thread safe.

Potential problems may not be evident at first, but can range from explicit errors such as exceptions, to incorrect results when sharing an instance of such an object in multiple threads.


## Recommendation
If the object is shared across instances, you should consider changing the code to use a non-static object of type `System.Security.Cryptography.ICryptoTransform` instead.

As an alternative, you could also look into using `ThreadStatic` attribute, but make sure you read the initialization remarks on the documentation.


## Example
This example demonstrates the dangers of using a static `System.Security.Cryptography.ICryptoTransform` in a way that generates incorrect results.


```csharp
internal class TokenCacheThreadUnsafeICryptoTransformDemo
{
    private static SHA256 _sha = SHA256.Create();

    public string ComputeHash(string data)
    {
        byte[] passwordBytes = UTF8Encoding.UTF8.GetBytes(data);
        return Convert.ToBase64String(_sha.ComputeHash(passwordBytes));
    }
}

class Program
{
    static void Main(string[] args)
    {
        int max = 1000;
        Task[] tasks = new Task[max];

        Action<object> action = (object obj) =>
        {
            var unsafeObj = new TokenCacheThreadUnsafeICryptoTransformDemo();
            if (unsafeObj.ComputeHash((string)obj) != "ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0=")
            {
                Console.WriteLine("**** We got incorrect Results!!! ****");
            }
        };

        for (int i = 0; i < max; i++)
        {
            // hash calculated on all threads should be the same:
            // ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0= (base64)
            // 
            tasks[i] = Task.Factory.StartNew(action, "abc");
        }

        Task.WaitAll(tasks);
    }
}

```
A simple fix is to change the `_sha` field from being a static member to an instance one by removing the `static` keyword.


```csharp
internal class TokenCacheThreadUnsafeICryptoTransformDemoFixed
{
    // We are replacing the static SHA256 field with an instance one
    //
    //private static SHA256 _sha = SHA256.Create();
    private SHA256 _sha = SHA256.Create();

    public string ComputeHash(string data)
    {
        byte[] passwordBytes = UTF8Encoding.UTF8.GetBytes(data);
        return Convert.ToBase64String(_sha.ComputeHash(passwordBytes));
    }
}

class Program
{
    static void Main(string[] args)
    {
        int max = 1000;
        Task[] tasks = new Task[max];

        Action<object> action = (object obj) =>
        {
            var safeObj = new TokenCacheThreadUnsafeICryptoTransformDemoFixed();
            if (safeObj.ComputeHash((string)obj) != "ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0=")
            {
                Console.WriteLine("**** We got incorrect Results!!! ****");
            }
        };

        for (int i = 0; i < max; i++)
        {
            // hash calculated on all threads should be the same:
            // ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0= (base64)
            // 
            tasks[i] = Task.Factory.StartNew(action, "abc");
        }

        Task.WaitAll(tasks);
    }
}

```

## References
* Microsoft documentation, [ThreadStaticAttribute Class](https://docs.microsoft.com/en-us/dotnet/api/system.threadstaticattribute?view=netframework-4.7.2).
* Stack Overflow, [Why does SHA1.ComputeHash fail under high load with many threads?](https://stackoverflow.com/questions/26592596/why-does-sha1-computehash-fail-under-high-load-with-many-threads).
* Common Weakness Enumeration: [CWE-362](https://cwe.mitre.org/data/definitions/362.html).