---
category: minorAnalysis
---
* The `py/tarslip` query now uses the correct argument positions and parameter names for `TarFile.extract` and `TarFile.extractall` sinks, reporting `extract(member=...)` calls with untrusted members and no longer falsely reporting `extractall(path, members)` calls when sanitized `members` are passed positionally.
