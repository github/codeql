# Improvements to Python analysis


 ## General improvements

 > Changes that affect alerts in many files or from many queries
> For example, changes to file classification
 ## New queries

 | **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Default version of SSL/TLS may be insecure (`py/insecure-default-protocol`) | security, external/cwe/cwe-327 | Finds instances where an insecure default protocol may be used. Results are shown on LGTM by default. |
| Insecure temporary file (`py/insecure-temporary-file`) | security, external/cwe/cwe-377 | Finds uses of the insecure and deprecated `tempfile.mktemp` function. Results are shown on LGTM by default. |
| Use of insecure SSL/TLS version (`py/insecure-protocol`) | security, external/cwe/cwe-327 | Finds instances where a known insecure protocol has been specified. Results are shown on LGTM by default. |

 ## Changes to existing queries

 | **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|

 ## Changes to code extraction

 * *Series of bullet points*

 ## Changes to QL libraries

 * *Series of bullet points*
