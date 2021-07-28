import java
import APIUsage
private import experimental.semmle.code.java.Logging

class ExternalAPI extends Callable {
  ExternalAPI() {
    not this.fromSource() and
    not this.getDeclaringType().getPackage().getName().matches("java.%") and
    not isJavaRuntime(this)
  }

  string jarName() { result = jarName(this.getCompilationUnit()) }

  string simpleName() {
    result = getDeclaringType().getSourceDeclaration() + "#" + this.getStringSignature()
  }
}

// TODO [bm]: Shall we move this into LoggingCall or a LoggingSetup predicate?
predicate loggingRelated(Call call) {
  call instanceof LoggingCall or
  call.getCallee().getName() = "getLogger" or // getLogger is not a LoggingCall
  call.getCallee().getName() = "isDebugEnabled" // org.slf4j.Logger#isDebugEnabled is not a LoggingCall
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
