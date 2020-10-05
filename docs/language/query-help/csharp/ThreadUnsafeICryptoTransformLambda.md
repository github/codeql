# Thread-unsafe capturing of an ICryptoTransform object

```
ID: cs/thread-unsafe-icryptotransform-captured-in-lambda
Kind: problem
Severity: warning
Precision: medium
Tags: concurrency security external/cwe/cwe-362

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Likely%20Bugs/ThreadUnsafeICryptoTransformLambda.ql)

Classes that implement `System.Security.Cryptography.ICryptoTransform` are not thread safe.

This problem is caused by the way these classes are implemented using Microsoft CAPI/CNG patterns.

For example, when a hash class implements this interface, there would typically be an instance-specific hash object created (for example using `BCryptCreateHash` function). This object can be called multiple times to add data to the hash (for example `BCryptHashData`). Finally, a function is called that finishes the hash and returns the data (for example `BCryptFinishHash`).

Allowing the same hash object to be called with data from multiple threads before calling the finish function could potentially lead to incorrect results.

For example, if you have multiple threads hashing `"abc"` on a static hash object, you may occasionally obtain the results (incorrectly) for hashing `"abcabc"`, or face other unexpected behavior.

It is very unlikely somebody outside Microsoft would write a class that implements `ICryptoTransform`, and even if they do, it is likely that they will follow the same common pattern as the existing classes implementing this interface.

Any object that implements `System.Security.Cryptography.ICryptoTransform` should not be used in concurrent threads as the instance members of such object are also not thread safe.

Potential problems may not be evident at first, but can range from explicit errors such as exceptions, to incorrect results when sharing an instance of such an object in multiple threads.


## Recommendation
Create new instances of the object that implements or has a field of type `System.Security.Cryptography.ICryptoTransform` to avoid sharing it accross multiple threads.


## Example
This example demonstrates the dangers of using a shared `System.Security.Cryptography.ICryptoTransform` in a way that generates incorrect results or may raise an exception.


```csharp
public static void RunThreadUnSafeICryptoTransformLambdaBad()
{
    const int threadCount = 4;
    // This local variable for a hash object is going to be shared across multiple threads
    var sha1 = SHA1.Create();
    var b = new Barrier(threadCount);
    Action start = () => {
        b.SignalAndWait();
        for (int i = 0; i < 1000; i++)
        {
            var pwd = Guid.NewGuid().ToString();
            var bytes = Encoding.UTF8.GetBytes(pwd);
            // This call may fail, or return incorrect results
            sha1.ComputeHash(bytes);
        }
    };
    var threads = Enumerable.Range(0, threadCount)
                            .Select(_ => new ThreadStart(start))
                            .Select(x => new Thread(x))
                            .ToList();
    foreach (var t in threads) t.Start();
    foreach (var t in threads) t.Join();
}

```
A simple fix is to change the local variable `sha1` being captured by the lambda to be a local variable within the lambda.


```csharp
public static void RunThreadUnSafeICryptoTransformLambdaFixed()
{
    const int threadCount = 4;
    var b = new Barrier(threadCount);
    Action start = () => {
        b.SignalAndWait();
        // The hash object is no longer shared
        for (int i = 0; i < 1000; i++)
        {
            var sha1 = SHA1.Create();
            var pwd = Guid.NewGuid().ToString();
            var bytes = Encoding.UTF8.GetBytes(pwd);
            sha1.ComputeHash(bytes);
        }
    };
    var threads = Enumerable.Range(0, threadCount)
                            .Select(_ => new ThreadStart(start))
                            .Select(x => new Thread(x))
                            .ToList();
    foreach (var t in threads) t.Start();
    foreach (var t in threads) t.Join();
}

```

## References
* Microsoft documentation, [ThreadStaticAttribute Class](https://docs.microsoft.com/en-us/dotnet/api/system.threadstaticattribute?view=netframework-4.7.2).
* Stack Overflow, [Why does SHA1.ComputeHash fail under high load with many threads?](https://stackoverflow.com/questions/26592596/why-does-sha1-computehash-fail-under-high-load-with-many-threads).
* Common Weakness Enumeration: [CWE-362](https://cwe.mitre.org/data/definitions/362.html).