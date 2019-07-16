# Improvements to Python analysis


## General improvements



### Impact on existing queries.



## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
| Arbitrary file write during tarfile extraction (`py/tarslip`) | security, external/cwe/cwe-022 | Finds instances where extracting from a tar archive can result in arbitrary file writes. Results are not shown on LGTM by default. |

