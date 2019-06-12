# Improvements to Java analysis

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Equals method does not inspect argument type (`java/unchecked-cast-in-equals`) | Fewer false positive and more true positive results | Precision has been improved by doing a bit of inter-procedural analysis and relying less on ad-hoc method names. |

## Changes to QL libraries

