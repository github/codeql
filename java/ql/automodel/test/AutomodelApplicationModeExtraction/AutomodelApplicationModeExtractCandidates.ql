import java
import AutomodelApplicationModeCharacteristics

from
  Endpoint endpoint, Top t, string package, string type, string name, string signature,
  string input, string output, string extensibleType
where
  isCandidate(endpoint, package, type, _, name, signature, input, output, _, extensibleType, _) and
  t = endpoint.asTop()
select t, package, type, name, signature, input, output, extensibleType
