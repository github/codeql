import java
import semmle.code.xml.MavenPom

/** Verify that the class is `pom.xml` to build the jar package exclusion class. */
predicate verifyClassWithPomJarExcludes(Class c) {
  not exists(Exclude e |
    e.getValue() = c.getPackage().getName().replaceAll(".", "/") + "/*" or
    e.getValue() = c.getPackage().getName().replaceAll(".", "/") + "/**" or
    e.getValue() = c.getPackage().getName().replaceAll(".", "/") + c.getName() + ".class" or
    e.getValue() = c.getPackage().getName().replaceAll(".", "/") + "/" + c.getName() + ".class"
  )
}

/** Verify that the class is `pom.xml` to build the war package exclusion class. */
predicate verifyClassWithPomWarExcludes(Class c) {
  not exists(PackagingExcludes pe |
    pe.getAnValue() =
      "WEB-INF/classes/" + c.getPackage().getName().replaceAll(".", "/") + c.getName() + ".class" or
    pe.getAnValue() =
      "WEB-INF/classes/" + c.getPackage().getName().replaceAll(".", "/") + "/" + c.getName() +
        ".class" or
    pe.getAnValue() = "WEB-INF/classes/" + c.getPackage().getName().replaceAll(".", "/") + "/*" or
    pe.getAnValue() = "WEB-INF/classes/" + c.getPackage().getName().replaceAll(".", "/") + "/**"
  )
}
