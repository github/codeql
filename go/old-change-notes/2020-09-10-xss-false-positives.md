lgtm,codescanning
* The query "Reflected cross-site scripting" (`go/reflected-xss`) now recognizes more cases of JSON marshaled data, which cannot serve as a vector for an XSS attack. This may reduce false-positive results for this query.
