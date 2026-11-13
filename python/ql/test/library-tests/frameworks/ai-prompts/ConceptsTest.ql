import python
import semmle.python.Concepts

from AIPrompt prompt, string systemKind, string userKind
where
  (if prompt.isSystemPrompt() then systemKind = "system" else systemKind = "") and
  (if prompt.isUserPrompt() then userKind = "user" else userKind = "")
select prompt, prompt.getAPrompt(), systemKind, userKind
