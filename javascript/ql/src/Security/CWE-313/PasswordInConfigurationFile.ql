/**
 * @name Password in configuration file
 * @description Storing unencrypted passwords in configuration files is unsafe.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/password-in-configuration-file
 * @tags security
 *       external/cwe/cwe-256
 *       external/cwe/cwe-260
 *       external/cwe/cwe-313
 */

import javascript

/**
 * Holds if some JSON or YAML file contains a property with name `key`
 * and value `val`, where `valElement` is the entity corresponding to the
 * value.
 *
 * Dependencies in `package.json` files are excluded by this predicate.
 */
predicate config(string key, string val, Locatable valElement) {
  exists(JSONObject obj | not exists(PackageJSON p | obj = p.getADependenciesObject(_)) |
    obj.getPropValue(key) = valElement and
    val = valElement.(JSONString).getValue()
  )
  or
  exists(YAMLMapping m, YAMLString keyElement |
    m.maps(keyElement, valElement) and
    key = keyElement.getValue() and
    val = valElement.(YAMLString).getValue()
  )
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

from string key, string val, Locatable valElement
where
  config(key, val, valElement) and
  val != "" and
  // exclude possible templates
  not val.regexpMatch(Templating::getDelimiterMatchingRegexp()) and
  (
    key.toLowerCase() = "password" and
    // exclude interpolations of environment variables
    not val.regexpMatch("\\$\\w+|\\$[{(].+[)}]|%.*%")
    or
    key.toLowerCase() != "readme" and
    // look for `password=...`, but exclude `password=;`, `password="$(...)"`,
    // `password=%s` and `password==`
    val.regexpMatch("(?is).*password\\s*=(?!\\s*;)(?!\"?[$`])(?!%s)(?!=).*")
  ) and
  not exclude(valElement.getFile())
select valElement, "Avoid plaintext passwords in configuration files."
