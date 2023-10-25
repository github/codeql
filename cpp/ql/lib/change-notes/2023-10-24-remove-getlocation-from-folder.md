---
category: breaking
---
* The `Container` and `Folder` classes now derive from `ElementBase` instead of `Locatable`, and no longer expose the `getLocation` predicate. Use `getURL` instead.
