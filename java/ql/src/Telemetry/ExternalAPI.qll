import java
import APIUsage
private import experimental.semmle.code.java.Logging

class ExternalAPI extends Callable {
  ExternalAPI() { not this.fromSource() }

  string simpleName() {
    result = getDeclaringType().getSourceDeclaration() + "#" + this.getStringSignature()
  }
}

class TestLibrary extends RefType {
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
