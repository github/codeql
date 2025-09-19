---
category: minorAnalysis
---

- The queries that check for unmatchable `$` and `^` in regular expressions did not account correctly for occurrences inside lookahead and lookbehind assertions. These occurrences are now handled correctly, eliminating this source of false positives.
