import javascript
import semmle.javascript.security.IncompleteBlacklistSanitizer

from IncompleteBlacklistSanitizer sanitizer
select sanitizer,
  "This " + sanitizer.getKind() + " sanitizer does not sanitize " +
    describeCharacters(sanitizer.getAnUnsanitizedCharacter())
