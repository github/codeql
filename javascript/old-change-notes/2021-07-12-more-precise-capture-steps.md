lgtm,codescanning
* Fixed a bug that could occur when data was tracked through a function whose parameter
  flows through a captured variable before reaching the return.
  This can lead to fewer false-positive results and more true-positive results.
