/** Provides classes and predicates for exclusions related to MaD models. */

import java

/** Holds if the given package `p` is a test package. */
pragma[nomagic]
private predicate isTestPackage(Package p) {
  p.getName()
      .matches([
          "org.junit%", "junit.%", "org.mockito%", "org.assertj%",
          "com.github.tomakehurst.wiremock%", "org.hamcrest%", "org.springframework.test.%",
          "org.springframework.mock.%", "org.springframework.boot.test.%", "reactor.test%",
          "org.xmlunit%", "org.testcontainers.%", "org.opentest4j%", "org.mockserver%",
          "org.powermock%", "org.skyscreamer.jsonassert%", "org.rnorth.visibleassertions",
          "org.openqa.selenium%", "com.gargoylesoftware.htmlunit%", "org.jboss.arquillian.testng%",
          "org.testng%"
        ])
}

/**
 * A test library.
 */
class TestLibrary extends RefType {
  TestLibrary() { isTestPackage(this.getPackage()) }
}

/** Holds if the given file is a test file. */
predicate isInTestFile(File file) {
  file.getAbsolutePath().matches(["%/test/%", "%/guava-tests/%", "%/guava-testlib/%"]) and
  not file.getAbsolutePath().matches(["%/ql/test/%", "%/ql/automodel/test/%"]) // allows our test cases to work
}

/** Holds if the given compilation unit's package is a JDK internal. */
private predicate isJdkInternal(CompilationUnit cu) {
  cu.getPackage().getName().matches("org.graalvm%") or
  cu.getPackage().getName().matches("com.sun%") or
  cu.getPackage().getName().matches("sun%") or
  cu.getPackage().getName().matches("jdk%") or
  cu.getPackage().getName().matches("java2d%") or
  cu.getPackage().getName().matches("build.tools%") or
  cu.getPackage().getName().matches("propertiesparser%") or
  cu.getPackage().getName().matches("org.jcp%") or
  cu.getPackage().getName().matches("org.w3c%") or
  cu.getPackage().getName().matches("org.ietf.jgss%") or
  cu.getPackage().getName().matches("org.xml.sax%") or
  cu.getPackage().getName().matches("com.oracle%") or
  cu.getPackage().getName().matches("org.omg%") or
  cu.getPackage().getName().matches("org.relaxng%") or
  cu.getPackage().getName() = "compileproperties" or
  cu.getPackage().getName() = "transparentruler" or
  cu.getPackage().getName() = "genstubs" or
  cu.getPackage().getName() = "netscape.javascript" or
  cu.getPackage().getName() = ""
}

/** Holds if the given compilation unit's package is internal. */
private predicate isInternal(CompilationUnit cu) {
  isJdkInternal(cu) or
  cu.getPackage().getName().matches("%internal%")
}

/** A method relating to lambda flow. */
private class LambdaFlowMethod extends Method {
  LambdaFlowMethod() {
    this.hasQualifiedName("java.lang", "Runnable", "run") or
    this.hasQualifiedName("java.util", "Comparator",
      ["comparing", "comparingDouble", "comparingInt", "comparingLong"]) or
    this.hasQualifiedName("java.util.function", "BiConsumer", "accept") or
    this.hasQualifiedName("java.util.function", "BiFunction", "apply") or
    this.hasQualifiedName("java.util.function", "Consumer", "accept") or
    this.hasQualifiedName("java.util.function", "Function", "apply") or
    this.hasQualifiedName("java.util.function", "Supplier", "get")
  }
}

/** Holds if the given callable is not worth modeling. */
predicate isUninterestingForModels(Callable c) {
  isInTestFile(c.getCompilationUnit().getFile()) or
  isInternal(c.getCompilationUnit()) or
  c instanceof MainMethod or
  c instanceof CloneMethod or
  c instanceof ToStringMethod or
  c instanceof LambdaFlowMethod or
  c instanceof StaticInitializer or
  exists(FunctionalExpr funcExpr | c = funcExpr.asMethod()) or
  c.getDeclaringType() instanceof TestLibrary or
  c.(Constructor).isParameterless()
}

/**
 * A class that represents all callables for which we might be
 * interested in having a MaD model.
 */
class ModelApi extends SrcCallable {
  ModelApi() {
    this.fromSource() and
    this.isEffectivelyPublic() and
    not isUninterestingForModels(this)
  }
}
