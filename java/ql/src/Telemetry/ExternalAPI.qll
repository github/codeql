/** Provides classes and predicates related to handling APIs from external libraries. */

private import java
private import APIUsage
private import semmle.code.java.dataflow.ExternalFlow

/**
 * An external API from either the Java Standard Library or a 3rd party library.
 */
class ExternalAPI extends Callable {
  ExternalAPI() { not this.fromSource() }

  /** Holds true if this API is part of a common testing library or framework */
  predicate isTestLibrary() { getDeclaringType() instanceof TestLibrary }

  /**
   * Gets information about the external API in the form expected by the CSV modeling framework.
   */
  string asCSV(ExternalAPI api) {
    result =
      api.getDeclaringType().getPackage() + ";?;" + api.getDeclaringType().getSourceDeclaration() +
        ";" + api.getName() + ";" + paramsString(api)
  }

  /** Holds true if this API is not yet supported by existing CodeQL libraries */
  predicate isSupported() { not supportKind(this) = "?" }

  /**
   * Gets the jar file containing this API. Normalizes the Java Runtime to "rt.jar" despite the presence of modules.
   */
  string jarContainer() { result = containerAsJar(this.getCompilationUnit().getParentContainer*()) }

  private string containerAsJar(Container container) {
    if container instanceof JarFile then result = container.getBaseName() else result = "rt.jar"
  }
}

private class TestLibrary extends RefType {
  TestLibrary() {
    getPackage()
        .getName()
        .matches([
            "org.junit%", "junit.%", "org.mockito%", "org.assertj%",
            "com.github.tomakehurst.wiremock%", "org.hamcrest%", "org.springframework.test.%",
            "org.springframework.mock.%", "org.springframework.boot.test.%", "reactor.test%",
            "org.xmlunit%", "org.testcontainers.%", "org.opentest4j%", "org.mockserver%",
            "org.powermock%", "org.skyscreamer.jsonassert%", "org.rnorth.visibleassertions",
            "org.openqa.selenium%", "com.gargoylesoftware.htmlunit%",
            "org.jboss.arquillian.testng%", "org.testng%"
          ])
  }
}
