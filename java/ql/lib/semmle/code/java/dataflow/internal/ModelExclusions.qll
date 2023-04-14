/** Provides classes and predicates for exclusions related to MaD models. */

import java

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
          "org.testng%", "%.test%"
        ])
}

/**
 * A test library.
 */
private class TestLibrary extends RefType {
  TestLibrary() { isTestPackage(this.getPackage()) }
}

private predicate isInTestFile(File file) {
  file.getAbsolutePath().matches("%src/test/%") or
  file.getAbsolutePath().matches("%/guava-tests/%") or
  file.getAbsolutePath().matches("%/guava-testlib/%")
}

private predicate isJdkInternal(CompilationUnit cu) {
  cu.getPackage().getName().matches("org.graalvm%") or
  cu.getPackage().getName().matches("com.sun%") or // ! maybe don't exclude `sun` ones? see SensitiveApi models again.
  cu.getPackage().getName().matches("sun%") or
  cu.getPackage().getName().matches("jdk%") or
  cu.getPackage().getName().matches("java2d%") or
  cu.getPackage().getName().matches("build.tools%") or
  cu.getPackage().getName().matches("propertiesparser%") or
  cu.getPackage().getName().matches("org.jcp%") or
  cu.getPackage().getName().matches("org.w3c%") or // ! maybe don't exclude these?
  cu.getPackage().getName().matches("org.ietf.jgss%") or
  cu.getPackage().getName().matches("org.xml.sax%") or
  cu.getPackage().getName().matches("com.oracle%") or
  cu.getPackage().getName().matches("org.omg%") or
  cu.getPackage().getName().matches("org.relaxng%") or
  cu.getPackage().getName() = "compileproperties" or
  cu.getPackage().getName() = "transparentruler" or
  cu.getPackage().getName() = "genstubs" or
  cu.getPackage().getName() = "netscape.javascript" or
  cu.getPackage().getName() = "" or
  cu.getPackage().getName().matches("%internal%")
}

/** Holds if the given callable is not worth modeling. */
private predicate isUninterestingForModels(Callable c) {
  c.getDeclaringType() instanceof TestLibrary or
  isInTestFile(c.getCompilationUnit().getFile()) or
  isJdkInternal(c.getCompilationUnit()) or
  c instanceof MainMethod or
  c instanceof StaticInitializer or
  exists(FunctionalExpr funcExpr | c = funcExpr.asMethod()) or
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
