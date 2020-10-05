# XPath injection

```
ID: go/xml/xpath-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-643

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-643/XPathInjection.ql)

If an XPath expression is built using string concatenation, and the components of the concatenation include user input, a user is likely to be able to create a malicious XPath expression.


## Recommendation
If user input must be included in an XPath expression, pre-compile the query and use variable references to include the user input.

For example, when using the `github.com/ChrisTrenkamp/goxpath` API, you can do this by creating a function that takes an `*goxpath.Opts` structure. In this structure you can then set the values of the variable references. This function can then be specified when calling `Exec()`, `Exec{Bool|Num|Node}()`, `ParseExec()`, or `MustExec()`.


## Example
In the first example, the code accepts a username specified by the user, and uses this unvalidated and unsanitized value in an XPath expression. This is vulnerable to the user providing special characters or string sequences that change the meaning of the XPath expression to search for different values.

In the second example, the XPath expression is a hard-coded string that specifies some variables, which are safely resolved at runtime using the `goxpath.Opts` structure.


```go
package main

import (
	"fmt"
	"net/http"

	"github.com/ChrisTrenkamp/goxpath"
	"github.com/ChrisTrenkamp/goxpath/tree"
)

func main() {}

func processRequest(r *http.Request, doc tree.Node) {
	r.ParseForm()
	username := r.Form.Get("username")

	// BAD: User input used directly in an XPath expression
	xPath := goxpath.MustParse("//users/user[login/text()='" + username + "']/home_dir/text()")
	unsafeRes, _ := xPath.ExecBool(doc)
	fmt.Println(unsafeRes)

	// GOOD: Value of parameters is defined here instead of directly in the query
	opt := func(o *goxpath.Opts) {
		o.Vars["username"] = tree.String(username)
	}
	// GOOD: Uses parameters to avoid including user input directly in XPath expression
	xPath = goxpath.MustParse("//users/user[login/text()=$username]/home_dir/text()")
	safeRes, _ := xPath.ExecBool(doc, opt)
	fmt.Println(safeRes)
}

```

## References
* OWASP: [Testing for XPath Injection](https://www.owasp.org/index.php?title=Testing_for_XPath_Injection_(OTG-INPVAL-010)).
* OWASP: [XPath Injection](https://www.owasp.org/index.php/XPATH_Injection).
* Common Weakness Enumeration: [CWE-643](https://cwe.mitre.org/data/definitions/643.html).