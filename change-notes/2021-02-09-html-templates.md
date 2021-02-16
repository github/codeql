lgtm,codescanning
* Improved our modeling of Go's builtin `html/template` package to understand that these templates provide context-sensitive escaping of HTML and Javascript special characters. This may reduce false-positives seen by the `go/reflected-xss` query, as well as other queries for which HTML escaping is relevant.
