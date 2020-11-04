lgtm,codescanning
* Inferring the lengths of implicitely sized arrays is fixed. Previously, multi
  dimensional arrays were always extracted with the same length for each dimension.
  With the fix, the array sizes `2` and `1` are extracted for `new int[,]{{1},{2}}`.
  Previously `2` and `2` were extracted.
