# Improvements to Python analysis


 ## General improvements

 > Changes that affect alerts in many files or from many queries
> For example, changes to file classification

The constants `MULTILINE` and `VERBOSE` in `re` module, are now understood for Python 3.6 and upward. 
Removes false positives seen when using Python 3.6, but not when using earlier versions.

 ## New queries

 | **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Default version of SSL/TLS may be insecure (`py/insecure-default-protocol`) | security, external/cwe/cwe-327 | Finds instances where an insecure default protocol may be used. Results are shown on LGTM by default. |
| Use of insecure SSL/TLS version (`py/insecure-protocol`) | security, external/cwe/cwe-327 | Finds instances where a known insecure protocol has been specified. Results are shown on LGTM by default. |

 ## Changes to existing queries

 | **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Unused import (`py/unused-import`) | Fewer false positive results | Results where the imported module is used in a `doctest` string are no longer reported. |
| Unused import (`py/unused-import`) | Fewer false positive results | Results where the imported module is used in a type-hint comment are no longer reported. |

 ## Changes to code extraction

 * *Series of bullet points*

 ## Changes to QL libraries

 * Added support for the `dill` pickle library.
