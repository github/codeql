---
category: minorAnalysis
---
* Regular expression checks using multiline (`m`) or unknown flags are no longer treated as generic taint sanitizers just because the pattern is anchored with `^` and `$`. This can reveal previously missed alerts, including command injection and reflected cross-site scripting.
