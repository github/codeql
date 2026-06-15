## 1.5.0

### Major Analysis Improvements

* The queries `cpp/wrong-type-format-argument`, `cpp/comparison-with-wider-type`, `cpp/integer-multiplication-cast-to-long`, `cpp/implicit-function-declaration` and `cpp/suspicious-add-sizeof` have had their precisions reduced from `high` to `medium`. They will also now give alerts for projects built with `build-mode: none`.
* The queries `cpp/wrong-type-format-argument`, `cpp/comparison-with-wider-type`, `cpp/integer-multiplication-cast-to-long` and `cpp/suspicious-add-sizeof` are no longer included in the `code-scanning` suite.

### Bug Fixes

* The predicate `occurenceCount` in the file module `MagicConstants` has been deprecated. Use `occurrenceCount` instead.
* The predicate `additionalAdditionOrSubstractionCheckForLeapYear` in the file module `LeapYear` has been deprecated. Use `additionalAdditionOrSubtractionCheckForLeapYear` instead.
