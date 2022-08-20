lgtm,codescanning
* The `js/xss` query now reports fewer false positives in cases where
  `location.hash` flows to a jQuery `$()` call in a way that preserves
  the `#` prefix.
