---
category: minorAnalysis
---
* Calls to reusable workflows and composite actions using the `$/` self repository syntax (for example `uses: $/.github/workflows/build.yml`) are now resolved in the same way as `./` references. This removes some false positive results and reports some results at their correct severity.
