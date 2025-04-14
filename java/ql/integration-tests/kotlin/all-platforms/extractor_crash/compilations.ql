import java

class AnonymousCompilation extends Compilation {
  override string toString() { result = "<compilation>" }
}

from Compilation c
select c,
  any(string s |
    if c.normalTermination() then s = "Normal termination" else s = "Not normal termination"
  ),
  any(string s |
    if c.extractionSuccessful()
    then s = "Extraction successful"
    else s = "Not extraction successful"
  ),
  any(string s |
    if c.recoverableErrors() then s = "Recoverable errors" else s = "Not recoverable errors"
  ),
  any(string s |
    if c.nonRecoverableErrors()
    then s = "Non-recoverable errors"
    else s = "Not non-recoverable errors"
  )
