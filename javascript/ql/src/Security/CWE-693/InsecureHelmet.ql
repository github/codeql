/**
 * @name Insecure configuration of Helmet security middleware
 * @description The Helmet middleware is used to set security-related HTTP headers in Express applications. This query finds instances where the middleware is configured with important security features disabled.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision high
 * @id javascript/insecure-helmet-configuration
 * @tags security
 *        cwe-693
 *        cwe-1021
 */

import semmle.javascript.frameworks.ExpressModules

class HelmetProperty extends Property {
  ExpressLibraries::HelmetRouteHandler helmet;

  HelmetProperty() {
    helmet.(DataFlow::CallNode).getAnArgument().asExpr().(ObjectExpr).getAProperty() = this
  }

  ExpressLibraries::HelmetRouteHandler getHelmet() { result = helmet }

  predicate isFalse() { this.getInit().(BooleanLiteral).getBoolValue() = false }

  predicate isImportantSecuritySetting() {
    this.getName() in ["frameguard", "contentSecurityPolicy"]
    // read from data extensions to allow enforcing other settings
    // TODO
  }
}

from HelmetProperty helmetSetting, ExpressLibraries::HelmetRouteHandler helmet
where
  helmetSetting.isFalse() and
  helmetSetting.isImportantSecuritySetting() and
  helmetSetting.getHelmet() = helmet
select helmet, "Helmet route handler, called with $@ set to 'false'.", helmetSetting,
  helmetSetting.getName()
