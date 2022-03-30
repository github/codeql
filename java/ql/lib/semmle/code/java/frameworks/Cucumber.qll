/**
 * Cucumber is an open-source project for writing executable acceptance tests in human-readable `.feature` files.
 */

import java

/**
 * An annotation defined in the Cucumber library.
 */
class CucumberAnnotation extends Annotation {
  CucumberAnnotation() { getType().getPackage().getName().matches("cucumber.api.java%") }
}

/**
 * A Cucumber interface for a specific language.
 */
class CucumberJava8Language extends Interface {
  CucumberJava8Language() {
    getASupertype().getAnAncestor().hasQualifiedName("cucumber.runtime.java8", "LambdaGlueBase")
  }
}

/**
 * A step definition for Cucumber.
 */
class CucumberStepDefinition extends Method {
  CucumberStepDefinition() { getAnAnnotation() instanceof CucumberAnnotation }
}

/**
 * A class containing Cucumber step definitions.
 */
class CucumberStepDefinitionClass extends Class {
  CucumberStepDefinitionClass() { getAMember() instanceof CucumberStepDefinition }
}
