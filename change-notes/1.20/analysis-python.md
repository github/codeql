# Improvements to Python analysis


 ## General improvements

 > Changes that affect alerts in many files or from many queries
> For example, changes to file classification
 ## New queries

 | **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Default version of SSL/TLS may be insecure (`py/insecure-default-protocol`) | security, external/cwe/cwe-327 | Finds instances where an insecure default protocol may be used. Results are shown on LGTM by default. |
| Overly permissive file permissions (`py/overly-permissive-file`) | security, external/cwe/cwe-732 | Finds instances where a file is created with overly permissive permissions. Results are not shown on LGTM by default. |
| Use of insecure SSL/TLS version (`py/insecure-protocol`) | security, external/cwe/cwe-327 | Finds instances where a known insecure protocol has been specified. Results are shown on LGTM by default. |

 ## Changes to existing queries

 | **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|

 ## Changes to code extraction

 * *Series of bullet points*

 ## Changes to QL libraries

 * Added support for the `dill` pickle library.
