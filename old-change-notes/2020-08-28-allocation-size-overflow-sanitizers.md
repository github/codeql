lgtm,codescanning
* The query "Size computation for allocation may overflow" has been improved to recognize more
  cases where the value should be considered to be safe, which should lead to fewer false
  positive results.
