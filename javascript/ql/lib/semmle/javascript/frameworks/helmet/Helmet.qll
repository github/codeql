/**
 * Provides classes for working with Helmet
 */

private import javascript

/**
 * A write to a property of a route handler from the "helmet" module.
 */
class HelmetProperty extends DataFlow::Node instanceof DataFlow::PropWrite {
  ExpressLibraries::HelmetRouteHandler helmet;

  HelmetProperty() {
    this = helmet.(DataFlow::CallNode).getAnArgument().getALocalSource().getAPropertyWrite()
  }

  /**
   * Gets the route handler associated to this property.
   */
  ExpressLibraries::HelmetRouteHandler getHelmet() { result = helmet }

  /**
   * Gets the boolean value of this property, if it may evaluate to a `Boolean`.
   */
  predicate isFalse() { DataFlow::PropWrite.super.getRhs().mayHaveBooleanValue(false) }

  /**
   * Gets the name of the `HelmetProperty`.
   */
  string getName() { result = DataFlow::PropWrite.super.getPropertyName() }

  /**
   * read from data extensions to allow enforcing custom settings
   */
  predicate isImportantSecuritySetting() { requiredHelmetSecuritySetting(this.getName()) }
}

/**
 * defaults are located in `javascript/ql/lib/semmle/frameworks/helmet/Helmet.Required.Setting.model.yml`
 */
extensible predicate requiredHelmetSecuritySetting(string name);
