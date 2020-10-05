# Improper control of generation of code

```
ID: cs/code-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-094 external/cwe/cwe-095 external/cwe/cwe-096

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-094/CodeInjection.ql)

If the application dynamically compiles and runs source code constructed from user input, a malicious user may be able to run arbitrary code.


## Recommendation
It is good practice not to generate, compile and run source code constructed from untrusted user input. If code must be dynamically generated using user input, the user input should be validated to prevent arbitrary code from appearing in the input. For example, a whitelist may be used to ensure that the input is limited to an acceptable range of values.


## Example
In the following example, the HttpHandler accepts remote user input which is C# source code for calculating tax. It compiles and runs this code, returning the output. However, the user provided source code is entirely unvalidated, and therefore allows arbitrary code execution.

If possible, the dynamic compilation should be removed all together, and replaced with a fixed set of tax calculation algorithms. If this is not sufficiently powerful, an interpreter could be provided for a safe, restricted language.


```csharp
using Microsoft.CSharp;
using System;
using System.CodeDom.Compiler;
using System.Reflection;
using System.Web;

public class CodeInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        // Code for calculating tax is provided as unvalidated user input
        string taxFormula = ctx.Request.QueryString["tax_formula"];
        // Used to create C#
        StringBuilder sourceCode = new StringBuilder("");
        sourceCode.Append("public class TaxCalc {\n");
        sourceCode.Append("\tpublic int CalculateTax(int value){\n");
        sourceCode.Append("\t\treturn " + taxFormula + "; \n");
        sourceCode.Append("\t}\n");
        sourceCode.Append("}\n");

        // BAD: This compiles the sourceCode, containing unvalidated user input
        CSharpCodeProvider c = new CSharpCodeProvider();
        ICodeCompiler icc = c.CreateCompiler();
        CompilerParameters cp = new CompilerParameters();
        CompilerResults cr = icc.CompileAssemblyFromSource(cp, sourceCode.ToString());

        // Compiled input is loaded, and an instance of the class is constructed
        System.Reflection.Assembly a = cr.CompiledAssembly;
        object taxCalc = a.CreateInstance("TaxCalc");

        // Unsafe code is executed
        Type taxCalcType = o.GetType();
        MethodInfo mi = type.GetMethod("CalculateTax");
        int value = int.Parse(ctx.Request.QueryString["value"]);
        int s = (int)mi.Invoke(o, new object[] { value });

        // Result is returned to the user
        ctx.Response.Write("Tax value is: " + s);
    }
}

```

## References
* Wikipedia: [Code Injection](https://en.wikipedia.org/wiki/Code_injection).
* OWASP: [Code Injection](https://www.owasp.org/index.php/Code_Injection).
* Common Weakness Enumeration: [CWE-94](https://cwe.mitre.org/data/definitions/94.html).
* Common Weakness Enumeration: [CWE-95](https://cwe.mitre.org/data/definitions/95.html).
* Common Weakness Enumeration: [CWE-96](https://cwe.mitre.org/data/definitions/96.html).