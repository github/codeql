/**
 * Provides classes for working with Helmet
 */

import javascript

class HelmetProperty extends DataFlow::Node instanceof DataFlow::PropWrite {
  ExpressLibraries::HelmetRouteHandler helmet;

  HelmetProperty() {
    this = helmet.(DataFlow::CallNode).getAnArgument().getALocalSource().getAPropertyWrite()
  }

  ExpressLibraries::HelmetRouteHandler getHelmet() { result = helmet }

  predicate isFalse() { DataFlow::PropWrite.super.getRhs().mayHaveBooleanValue(false) }

  string getName() { result = DataFlow::PropWrite.super.getPropertyName() }

  predicate isImportantSecuritySetting() {
    // read from data extensions to allow enforcing custom settings
    // defaults are located in javascript/ql/lib/semmle/frameworks/helmet/Helmet.Required.Setting.model.yml
    requiredHelmetSecuritySetting(this.getName())
  }
}

extensible predicate requiredHelmetSecuritySetting(string name);
