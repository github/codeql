/** Classses and predicates for reasoning about passwords in configuration files. */

import javascript
import semmle.javascript.RestrictedLocations
import semmle.javascript.security.SensitiveActions

/**
 * Holds if some JSON or YAML file contains a property with name `key`
 * and value `val`, where `valElement` is the entity corresponding to the
 * value.
 *
 * The following are excluded by this predicate:
 * - Dependencies in `package.json` files.
 * - Values that look like template delimiters.
 * - Files that appear to be API-specifications, dictonary, test, or example.
 */
predicate config(string key, string val, Locatable valElement) {
  (
    exists(JsonObject obj | not exists(PackageJson p | obj = p.getADependenciesObject(_)) |
      obj.getPropValue(key) = valElement and
      val = valElement.(JsonString).getValue()
    )
    or
    exists(YAMLMapping m, YAMLString keyElement |
      m.maps(keyElement, valElement) and
      key = keyElement.getValue() and
      (
        val = valElement.(YAMLString).getValue()
        or
        valElement.toString() = "" and
        val = ""
      )
    )
  ) and
  // exclude possible templates
  not val.regexpMatch(Templating::getDelimiterMatchingRegexp()) and
  not exclude(valElement.getFile())
}

/**
 * Holds if file `f` should be excluded because it looks like it may be
 * an API specification, a dictionary file, or a test or example.
 */
predicate exclude(File f) {
  f.getRelativePath().regexpMatch("(?i).*(^|/)(lang(uage)?s?|locales?|tests?|examples?|i18n)/.*")
  or
  f.getStem().regexpMatch("(?i)translations?")
  or
  f.getExtension().toLowerCase() = "raml"
}
