lgtm,codescanning
* The `Buffer` library considers more fields to be of variable size
  for array members of size 0 or 1. Buffer size calculation of array type
  fields of size 0 or 1 in unions are considered pointers to the union
  and will return the size of the union itself. The changes reduces
  the number of false positives in cpp/static-buffer-overflow
