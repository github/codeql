private import java
private import APIUsage
private import semmle.code.java.dataflow.ExternalFlow

class ExternalAPI extends Callable {
  ExternalAPI() { not this.fromSource() }

  predicate isTestLibrary() { getDeclaringType() instanceof TestLibrary }

  predicate isInteresting() {
    getNumberOfParameters() > 0 and
    exists(Type retType | retType = getReturnType() |
      not retType instanceof VoidType and
      not retType instanceof PrimitiveType and
      not retType instanceof BoxedType
    )
  }

  string asCSV(ExternalAPI api) {
    result =
      api.getDeclaringType().getPackage() + ";?;" + api.getDeclaringType().getSourceDeclaration() +
        ";" + api.getName() + ";" + paramsString(api)
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
