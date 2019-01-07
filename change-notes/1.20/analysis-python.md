# Improvements to Python analysis


 ## General improvements

 > Changes that affect alerts in many files or from many queries
> For example, changes to file classification
 ## New queries

 | **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Default version of SSL/TLS may be insecure (`py/insecure-default-protocol`) | security, external/cwe/cwe-327 | Results are shown on LGTM by default. |
| Use of insecure SSL/TLS version (`py/insecure-protocol`) | security, external/cwe/cwe-327 | Results are shown on LGTM by default. |

 ## Changes to existing queries

 All taint-tracking queries now support visualization of paths in QL for Eclipse.
Most security alerts are now visible on LGTM by default.

 | **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|

 ## Changes to code extraction

 * *Series of bullet points*

 ## Changes to QL libraries

 * *Series of bullet points*
