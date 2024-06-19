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
    or
    // read from data extensions to allow enforcing other settings
    requiredHelmetSecuritySetting(this.getName())
  }
}

/*
 * Extend the required Helmet security settings using data extensions.
 * Docs: https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-javascript/
 * For example:
 *
 * extensions:
 *  - addsTo:
 *      pack: codeql/javascript-all
 *      extensible: requiredHelmetSecuritySetting
 *    data:
 *      - name: "frameguard"
 *
 * Note: `frameguard` is an example: the query already enforces this setting, so it is not necessary to add it to the data extension.
 */

extensible predicate requiredHelmetSecuritySetting(string name);

from HelmetProperty helmetProperty, ExpressLibraries::HelmetRouteHandler helmet
where
  helmetSetting.isFalse() and
  helmetSetting.isImportantSecuritySetting() and
  helmetSetting.getHelmet() = helmet
select helmet, "Helmet route handler, called with $@ set to 'false'.", helmetSetting,
  helmetSetting.getName()
