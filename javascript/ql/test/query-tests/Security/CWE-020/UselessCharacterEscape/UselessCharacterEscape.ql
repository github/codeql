import javascript
import semmle.javascript.CharacterEscapes::CharacterEscapes

from DataFlow::Node n, string char
where
  char = getAnIdentityEscapedCharacter(n, _, _) and
  not hasALikelyRegExpPatternMistake(n) and
  not char = "\n" // ignore escaped newlines in multiline strings
select n, "The escape sequence '\\" + char + "' is equivalent to just '" + char + "'."
