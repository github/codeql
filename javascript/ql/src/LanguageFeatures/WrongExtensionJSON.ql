/**
 * @name JSON in JavaScript file
 * @description Storing JSON in files with extension 'js' or 'jsx' is error-prone.
 * @kind problem
 * @problem.severity recommendation
 * @id js/json-in-javascript-file
 * @tags maintainability
 *       language-features
 * @precision low
 */

import javascript

from JsonValue v, File f
where
  f = v.getFile() and
  f.getExtension().regexpMatch("(?i)jsx?") and
  not exists(v.getParent())
select v, "JSON data in file with extension '" + f.getExtension() + "'."
