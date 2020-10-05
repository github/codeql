# CGI script vulnerable to cross-site scripting

```
ID: cpp/cgi-xss
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-079

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-079/CgiXss.ql)

Directly writing an HTTP request parameter back to a web page allows for a cross-site scripting vulnerability. The data is displayed in a user's web browser as belonging to one site, but it is provided by some other site that the user browses to. In effect, such an attack allows one web site to insert content in the other one.

For web servers implemented with the Common Gateway Interface (CGI), HTTP parameters are supplied via the `QUERY_STRING` environment variable.


## Recommendation
To guard against cross-site scripting, consider escaping special characters before writing the HTTP parameter back to the page.


## Example
In the following example, the `bad_server` writes a parameter directly back to the HTML page that the user will see. The `good_server` first escapes any HTML special characters before writing to the HTML page.


```c
void bad_server() {
  char* query = getenv("QUERY_STRING");
  puts("<p>Query results for ");
  // BAD: Printing out an HTTP parameter with no escaping
  puts(query);
  puts("\n<p>\n");
  puts(do_search(query));
}

void good_server() {
  char* query = getenv("QUERY_STRING");
  puts("<p>Query results for ");
  // GOOD: Escape HTML characters before adding to a page
  char* query_escaped = escape_html(query);
  puts(query_escaped);
  free(query_escaped);

  puts("\n<p>\n");
  puts(do_search(query));
}

```

## References
* OWASP: [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html).
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting).
* IETF Tools: [The Common Gateway Specification (CGI)](http://tools.ietf.org/html/draft-robinson-www-interface-00).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).