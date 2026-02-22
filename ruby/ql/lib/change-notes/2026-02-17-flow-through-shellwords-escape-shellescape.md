---
category: minorAnalysis
---
* We now track taint flow through `Shellwords.escape` and `Shellwords.shellescape` for all queries except command injection, for which they are sanitizers.
