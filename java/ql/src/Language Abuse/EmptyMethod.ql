/**
 * @id java/empty-method
 * @name J-D-002: An empty method serves no purpose and may indicate programmer error
 * @description An empty method serves no purpose and makes code less readable. An empty method may
 *              indicate an error on the part of the developer.
 * @kind problem
 * @precision very-high
 * @problem.severity warning
 * @tags correctness
 *       maintainability
 *       readability
 */

import java

/**
 * Represents a likely a test method, which is either a method that is already
 * recognized as a `TestMethod` or something that is likely a JUnit test or
 * something in the expected test path for Java tests.
 */
class LikelyTestMethod extends Method {
  LikelyTestMethod() {
    this.getDeclaringType() instanceof TestClass
    or
    this instanceof TestMethod
    or
    this instanceof LikelyJunitTest
    or
    //standard Maven/Gradle test file discovery filepath
    this.getFile().getAbsolutePath().matches("%src/test/java%")
    or
    this.getDeclaringType() instanceof SurefireTest
  }
}

/**
 * Classes that are likely part of junit tests (more general than `TestMethod` from `UnitTest.qll`)
 * A `Method` that is public, has no parameters,
 * has a "void" return type, AND either has a name that starts with "test" OR
 * has an annotation that ends with "Test"
 */
class LikelyJunitTest extends Method {
  LikelyJunitTest() {
    this.isPublic() and
    this.getReturnType().hasName("void") and
    this.hasNoParameters() and
    (
      this.getName().matches("JUnit%") or
      this.getName().matches("test%") or
      this.getAnAnnotation().toString().matches("%Test")
    )
  }
}

/**
 * Maven surefire patterns to consider which files are testcases:
 * https://maven.apache.org/surefire/maven-surefire-plugin/examples/inclusion-exclusion.html
 */
class SurefireTest extends Class {
  SurefireTest() {
    this.getFile().getAbsolutePath().matches("%src/test/java%") and
    this.getFile()
        .getBaseName()
        .matches(["Test%.java", "%Test.java", "%Tests.java", "%TestCase.java"])
  }
}

/**
 * Frameworks that provide `PointCuts`
 * which commonly intentionally annotate empty methods
 */
class PointCutAnnotation extends Annotation {
  PointCutAnnotation() {
    this.getType().hasQualifiedName("org.aspectj.lang.annotation", "Pointcut")
  }
}

/**
 * A `Method` from source that is not abstract
 */
class NonAbstractSource extends Method {
  NonAbstractSource() {
    this.fromSource() and
    not this.isAbstract() and
    not this instanceof LikelyTestMethod
  }
}

from NonAbstractSource m
where
  //empty
  not exists(m.getBody().getAChild()) and
  //permit comment lines explaining why this is empty
  m.getNumberOfCommentLines() = 0 and
  //permit a javadoc above as well as sufficient reason to leave empty
  not exists(Javadoc jd | m.getDoc().getJavadoc() = jd) and
  //methods annotated this way are usually intentionally empty
  not exists(PointCutAnnotation a | a = m.getAnAnnotation())
select m, "Empty method found."
