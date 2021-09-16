lgtm,codescanning
* The `memberMayBeVarSize` predicate considers more fields to be variable size.
  As a result, the "Static buffer overflow" query (cpp/static-buffer-overflow)
  produces fewer false positives.
