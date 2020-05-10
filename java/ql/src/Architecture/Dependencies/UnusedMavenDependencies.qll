/** Provides classes and predicates for working with Maven dependencies. */

import java
import semmle.code.xml.MavenPom

/**
 * Holds if the source code in the project represented by the given pom depends on any code
 * within the given container (folder, jar file etc.).
 */
predicate pomDependsOnContainer(Pom f, Container g) {
  exists(RefType source, RefType target |
    source.getFile().getParentContainer*() = f.getFile().getParentContainer() and
    target.getFile().getParentContainer*() = g and
    depends(source, target)
  )
}

/**
 * Holds if the source code in the project represented by the sourcePom depends on any code
 * within the project represented by the targetPom.
 */
predicate pomDependsOnPom(Pom sourcePom, Pom targetPom) {
  exists(RefType source, RefType target |
    source.getFile().getParentContainer*() = sourcePom.getFile().getParentContainer() and
    target.getFile().getParentContainer*() = targetPom.getFile().getParentContainer() and
    depends(source, target)
  )
}
