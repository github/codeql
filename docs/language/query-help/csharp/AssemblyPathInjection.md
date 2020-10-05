# Assembly path injection

```
ID: cs/assembly-path-injection
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-114

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-114/AssemblyPathInjection.ql)

C# supports runtime loading of assemblies by path through the use of the `System.Reflection.Assembly` API. If an external user can influence the path used to load an assembly, then the application can potentially be tricked into loading an assembly which was not intended to be loaded, and executing arbitrary code.


## Recommendation
Avoid loading assemblies based on user provided input. If this is not possible, ensure that the path is validated before being used with `Assembly`. For example, compare the provided input against a whitelist of known safe assemblies, or confirm that the path is restricted to a single directory which only contains safe assemblies.


## Example
In this example, user input is provided describing the path to an assembly, which is loaded without validation. This is problematic because it allows the user to load any assembly installed on the system, and is particularly problematic if an attacker can upload a custom DLL elsewhere on the system.


```csharp
using System;
using System.Web;
using System.Reflection;

public class AssemblyPathInjectionHandler : IHttpHandler {
  public void ProcessRequest(HttpContext ctx) {
    string assemblyPath = ctx.Request.QueryString["assemblyPath"];

    // BAD: Load assembly based on user input
    var badAssembly = Assembly.LoadFile(assemblyPath);

    // Method called on loaded assembly. If the user can control the loaded assembly, then this
    // could result in a remote code execution vulnerability
    MethodInfo m = badAssembly.GetType("Config").GetMethod("GetCustomPath");
    Object customPath = m.Invoke(null, null);
    // ...
  }
}
```
In the corrected version, user input is validated against one of two options, and the assembly is only loaded if the user input matches one of those options.


```csharp
using System;
using System.Web;
using System.Reflection;

public class AssemblyPathInjectionHandler : IHttpHandler {
  public void ProcessRequest(HttpContext ctx) {
    string configType = ctx.Request.QueryString["configType"];

    if (configType.equals("configType1") || configType.equals("configType2")) {
      // GOOD: Loaded assembly is one of the two known safe options
      var safeAssembly = Assembly.LoadFile(@"C:\SafeLibraries\" + configType + ".dll");

      // Code execution is limited to one of two known and vetted assemblies
      MethodInfo m = safeAssembly.GetType("Config").GetMethod("GetCustomPath");
      Object customPath = m.Invoke(null, null);
      // ...
    }
  }
}
```

## References
* Microsoft: [System.Reflection.Assembly](https://docs.microsoft.com/en-us/dotnet/api/system.reflection.assembly?view=netframework-4.8).
* Common Weakness Enumeration: [CWE-114](https://cwe.mitre.org/data/definitions/114.html).