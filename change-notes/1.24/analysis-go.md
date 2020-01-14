# Improvements to Go analysis

## General improvements

* Alert suppression can now be done with single-line block comments (`/* ... */`) as well as line comments (`// ...`).
* More sources of untrusted input are modelled, which may lead to more results from the security queries.

## New queries

| **Query**                                                                 | **Tags**                                                                   | **Purpose**                                                                                                                                            |
|---------------------------------------------------------------------------|----------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| Constant length comparison (`go/constant-length-comparison`)     | correctness | Highlights code that checks the length of an array or slice against a constant before indexing it using a variable, suggesting a logic error. Results are shown on LGTM by default. |
| Impossible interface nil check (`go/impossible-interface-nil-check`) | correctness | Highlights code that compares an interface value that cannot be `nil` to `nil`, suggesting a logic error. Results are shown on LGTM by default. |
| Incomplete URL scheme check (`go/incomplete-url-scheme-check`) | correctness, security, external/cwe/cwe-020 | Highlights checks for `javascript` URLs that do not take `data` or `vbscript` URLs into account. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                                           | **Expected impact**          | **Change**                                                |
|-----------------------------------------------------|------------------------------|-----------------------------------------------------------|
| Database query built from user-controlled sources (`go/sql-injection`) | More results | The library models used by the query have been improved, allowing it to flag more potentially problematic cases. |
| Reflected cross-site scripting (`go/reflected-xss`) | Fewer results | Untrusted input flowing into an HTTP header definition is no longer flagged, since this is often harmless. |
| Useless assignment to field (`go/useless-assignment-to-field`) | Fewer false positives | The query now conservatively handles fields promoted through embedded pointer types. |
| Identical operands (`go/redundant-operation`) | Fewer false positives | The query no longer flags cases where the operands have the same value but are syntactically distinct, since this is usually intentional. |
| Incomplete regular expression for hostnames (`go/incomplete-hostname-regexp`) | More results | The query now flags unescaped dots before the TLD in a hostname regex. |
