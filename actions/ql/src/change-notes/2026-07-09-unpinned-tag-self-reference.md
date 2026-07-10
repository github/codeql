---
category: minorAnalysis
---
* The `actions/unpinned-tag` query no longer reports `$/` same-repo self-references (e.g. `uses: $/path/to/action`), which are inherently pinned to the running commit, just like `./` local references.
