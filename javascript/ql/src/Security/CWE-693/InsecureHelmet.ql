/**
 * @name Insecure configuration of Helmet security middleware
 * @description The Helmet middleware is used to set security-related HTTP headers in Express applications. This query finds instances where the middleware is configured with important security features disabled.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision high
 * @id js/insecure-helmet-configuration
 * @tags security
 *        external/cwe/cwe-693
 *        external/cwe/cwe-1021
 */

import javascript
import semmle.javascript.frameworks.ExpressModules
import semmle.javascript.frameworks.helmet.Helmet

from HelmetProperty helmetProperty, ExpressLibraries::HelmetRouteHandler helmet
where
  helmetProperty.isFalse() and
  helmetProperty.isImportantSecuritySetting() and
  helmetProperty.getHelmet() = helmet
select helmet,
  "Helmet security middleware, configured with security setting $@ set to 'false', which disables enforcing that feature.",
  helmetProperty, helmetProperty.getName()
