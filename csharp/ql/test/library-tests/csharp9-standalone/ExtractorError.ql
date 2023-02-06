import csharp
import semmle.code.csharp.commons.Diagnostics

from ExtractorError error
where not exists(CompilerError ce | ce.getLocation().getFile() = error.getLocation().getFile())
select error,
  "Unexpected " + error.getOrigin() + " error: " + error.getText() + "\n" + error.getStackTrace()
