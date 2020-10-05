# XPath injection

```
ID: cs/xml/xpath-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-643

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/CWE-643/XPathInjection.ql)

If an XPath expression is built using string concatenation, and the components of the concatenation include user input, a user is likely to be able to create a malicious XPath expression.


## Recommendation
If user input must be included in an XPath expression, pre-compile the query and use variable references to include the user input.

When using the `System.Xml.XPath` API, this can be done by creating a custom subtype of `System.Xml.Xsl.XsltContext`, and implementing `ResolveVariable(String,?String)` to return the user provided data. This custom context can be specified for a given `XPathExpression` using `XPathExpression.SetContext()`. For more details, see the "User Defined Functions and Variables" webpage in the list of references.


## Example
In the first example, the code accepts a user name specified by the user, and uses this unvalidated and unsanitized value in an XPath expression. This is vulnerable to the user providing special characters or string sequences that change the meaning of the XPath expression to search for different values.

In the second example, the XPath expression is a hard-coded string that specifies some variables, which are safely replaced at runtime using a custom `XsltContext` that looks up the variables in an `XsltArgumentList`.


```csharp
using System;
using System.Web;
using System.Xml.XPath;

public class XPathInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string userName = ctx.Request.QueryString["userName"];

        // BAD: Use user-provided data directly in an XPath expression
        string badXPathExpr = "//users/user[login/text()='" + userName + "']/home_dir/text()";
        XPathExpression.Compile(badXPathExpr);

        // GOOD: XPath expression uses variables to refer to parameters
        string xpathExpression = "//users/user[login/text()=$username]/home_dir/text()";
        XPathExpression xpath = XPathExpression.Compile(xpathExpression);

        // Arguments are provided as a XsltArgumentList()
        XsltArgumentList varList = new XsltArgumentList();
        varList.AddParam("userName", string.Empty, userName);

        // CustomContext is an application specific class, that looks up variables in the
        // expression from the varList.
        CustomContext context = new CustomContext(new NameTable(), varList)
      xpath.SetContext(context);
    }
}

```

## References
* OWASP: [Testing for XPath Injection](https://www.owasp.org/index.php?title=Testing_for_XPath_Injection_(OTG-INPVAL-010)).
* OWASP: [XPath Injection](https://www.owasp.org/index.php/XPATH_Injection).
* MSDN: [User Defined Functions and Variables](https://msdn.microsoft.com/en-us/library/dd567715.aspx).
* Common Weakness Enumeration: [CWE-643](https://cwe.mitre.org/data/definitions/643.html).