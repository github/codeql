# Deserialization of untrusted data

```
ID: cs/unsafe-deserialization-untrusted-input
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-502

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-502/UnsafeDeserializationUntrustedInput.ql)

Deserializing an object from untrusted input may result in security problems, such as denial of service or remote code execution.


## Recommendation
Avoid deserializing objects from an untrusted source, and if not possible, make sure to use a safe deserialization framework.


## Example
In this example, text from an HTML text box is deserialized using a `JavaScriptSerializer` with a simple type resolver. Using a type resolver means that arbitrary code may be executed.


```csharp
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

class Bad
{
    public static object Deserialize(TextBox textBox)
    {
        JavaScriptSerializer sr = new JavaScriptSerializer(new SimpleTypeResolver());
        // BAD
        return sr.DeserializeObject(textBox.Text);
    }
}

```
To fix this specific vulnerability, we avoid using a type resolver. In other cases, it may be necessary to use a different deserialization framework.


```csharp
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

class Good
{
    public static object Deserialize(TextBox textBox)
    {
        JavaScriptSerializer sr = new JavaScriptSerializer();
        // GOOD
        return sr.DeserializeObject(textBox.Text);
    }
}

```

## References
* Mu&ntilde;oz, Alvaro and Mirosh, Oleksandr: [JSON Attacks](https://www.blackhat.com/docs/us-17/thursday/us-17-Munoz-Friday-The-13th-Json-Attacks.pdf).
* Common Weakness Enumeration: [CWE-502](https://cwe.mitre.org/data/definitions/502.html).