# Improvements to Python analysis


## General improvements

### Points-to
Tracking of "unknown" values from modules that are absent from the database has been improved. Particularly when an "unknown" value is used as a decorator, the decorated function is tracked.


### Impact on existing queries.


## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
| Arbitrary file write during tarfile extraction (`py/tarslip`) | security, external/cwe/cwe-022 | Finds instances where extracting from a tar archive can result in arbitrary file writes. Results are not shown on LGTM by default. |

## Changes to existing queries
| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Unreachable Code (`py/unreachable-statement`) | Fewer false positive results | When there is a risk that the control flow graph is erroneously pruned because of a chained comparison, the results are no longer reported. |
