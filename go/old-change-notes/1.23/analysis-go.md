# Improvements to Go analysis

## New queries

| **Query**                                                                 | **Tags**                                                                   | **Purpose**                                                                                                                                            |
|---------------------------------------------------------------------------|----------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| Clear-text logging of sensitive information (`go/clear-text-logging`)     | security, external/cwe/cwe-312, external/cwe/cwe-315, external/cwe/cwe-359 | Highlights code that writes sensitive information to a log file, or to the console, without encryption or hashing. Results are shown on LGTM by default. |
| Open URL redirect (`go/unvalidated-url-redirection`)                      | security, external/cwe/cwe-601                                             | Highlights code that redirects to a URL that may be controlled by an attacker. Results are shown on LGTM by default.                                   |

## Changes to existing queries

| **Query**                                           | **Expected impact**          | **Change**                                                |
|-----------------------------------------------------|------------------------------|-----------------------------------------------------------|
| Expression has no effect (`go/useless-expression`)  | Fewer false positive results | This query no longer flags calls to empty stub functions. |
| Hard-coded credentials (`go/hardcoded-credentials`) | Fewer false positive results | This query now recognizes more placeholder credentials.   |
