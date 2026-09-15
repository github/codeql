---
category: minorAnalysis
---
* The `actions/unpinned-tag` query no longer reports `$/` self repository references (e.g. `uses: $/path/to/action`), which resolve to the same repository at the running commit and are therefore inherently pinned, just like `./` self workspace (local) references.
