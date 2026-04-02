---
category: minorAnalysis
---
* The "Extraction warnings" (`cpp/diagnostics/extraction-warnings`) diagnostics query no longer yields `ExtractionRecoverableWarning`s for `build-mode: none` databases. The results were found to significantly increase the sizes of the produced SARIF files, making them unprocessable in some cases.
