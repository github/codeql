lgtm,codescanning
* The query "Incorrect conversion between integer types" has been improved to
  treat `math.MaxUint` and `math.MaxInt` as the values they would be on a
  32-bit architecture. This should lead to fewer false positive results.
