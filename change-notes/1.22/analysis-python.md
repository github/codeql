# Improvements to Python analysis


## General improvements

### Points-to
Tracking of "unknown" values from modules that are absent from the database has been improved. Particularly when an "unknown" value is used as a decorator, the decorated function is tracked.


### Impact on existing queries.


## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
| Arbitrary file write during tarfile extraction (`py/tarslip`) | security, external/cwe/cwe-022 | Finds instances where extracting from a tar archive can result in arbitrary file writes. Results are not shown on LGTM by default. |

