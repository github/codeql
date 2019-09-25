# Improvements to Python analysis


## General improvements



## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
| Clear-text logging of sensitive information (`py/clear-text-logging-sensitive-data`) | security, external/cwe/cwe-312 | Finds instances where sensitive information is logged without encryption or hashing. Results are shown on LGTM by default. |
| Clear-text storage of sensitive information (`py/clear-text-storage-sensitive-data`) | security, external/cwe/cwe-312 | Finds instances where sensitive information is stored without encryption or hashing. Results are shown on LGTM by default. |
| Missing rate limiting (`py/missing-rate-limiting`) | security, external/cwe/cwe-770 | An HTTP request handler that performs expensive operations without restricting the rate at which operations can be carried out is vulnerable to denial-of-service attacks. |

