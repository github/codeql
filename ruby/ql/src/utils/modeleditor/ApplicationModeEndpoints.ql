/**
 * @name Fetch endpoints for use in the model editor (application mode)
 * @description A list of 3rd party endpoints (methods and attributes) used in the codebase. Excludes test and generated code.
 * @kind table
 * @id rb/utils/modeleditor/application-mode-endpoints
 * @tags modeleditor endpoints application-mode
 */

import codeql.ruby.AST

// This query is empty as Application Mode is not yet supported for Ruby.
from
  Call usage, string package, string type, string name, string parameters, boolean supported,
  string namespace, string version, string supportedType, string classification
where none()
select usage, package, namespace, type, name, parameters, supported, namespace, version,
  supportedType, classification
