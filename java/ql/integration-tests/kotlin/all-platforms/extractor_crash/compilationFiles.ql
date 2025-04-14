import java

class AnonymousCompilation extends Compilation {
  override string toString() { result = "<compilation>" }
}

from Compilation c, int i, File f
where f = c.getFileCompiled(i)
select c, i, f,
  any(string s |
    if c.fileCompiledSuccessful(i)
    then s = "Extraction successful"
    else s = "Not extraction successful"
  ),
  any(string s |
    if c.fileCompiledRecoverableErrors(i)
    then s = "Recoverable errors"
    else s = "Not recoverable errors"
  ),
  any(string s |
    if c.fileCompiledNonRecoverableErrors(i)
    then s = "Non-recoverable errors"
    else s = "Not non-recoverable errors"
  )
