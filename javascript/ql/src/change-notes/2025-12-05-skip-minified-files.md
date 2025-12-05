---
category: majorAnalysis
---
* JavaScript files with an average line length greater than 200 are now considered minified and will no longer be analyzed.
  For use-cases where minified files should be analyzed, the orginal behaviour can be restored by setting the environment variable
  `CODEQL_EXTRACTOR_JAVASCRIPT_ALLOW_MINIFIED_FILES=true`.
