---
category: newQuery
---

* Added new query "System command built from user-controlled sources" (`swift/command-line-injection`) for Swift. This query detects system commands built from user-controlled sources without sufficient validation. The query was previously [contributed to the 'experimental' directory by @maikypedia](https://github.com/github/codeql/pull/13726) but will now run by default for all code scanning users.
