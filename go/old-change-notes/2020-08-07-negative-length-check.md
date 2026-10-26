lgtm,codescanning
* Query "Redundant check for negative value" (`go/negative-length-check`) has been expanded to consider unsigned integers, along
  with the return values of `len` and `cap` which it already handled. It has also been renamed to match its expanded role.
