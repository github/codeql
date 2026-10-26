import javascript

// The error message and location depends on the TypeScript version
// so just report on a per-file basis.
from File file
where exists(JSParseError error | error.getFile() = file)
select file.getRelativePath(), "This file contains a parse error"
