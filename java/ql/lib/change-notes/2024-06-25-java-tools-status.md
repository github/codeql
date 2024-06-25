---
category: minorAnalysis
---
* Java build-mode `none` analyses now only report a warning on the CodeQL status page when there are significant analysis problems-- defined as 5% of expressions lacking a type, or 5% of call targets being unknown. Other messages reported on the status page are downgraded from warnings to notes and so are less prominent, but are still available for review.
