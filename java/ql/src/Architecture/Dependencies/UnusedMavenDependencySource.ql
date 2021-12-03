/**
 * @name Unused Maven dependency (source)
 * @description Unnecessary Maven dependencies are a maintenance burden.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/unused-maven-source-dependency
 */

import java
import semmle.code.xml.MavenPom
import UnusedMavenDependencies

from PomDependency d, Pom source, Pom target
where
  source.getADependency() = d and
  // We have a targetPom file, so this is a "source" dependency, rather than a binary dependency
  // from the Maven repository. Note, although .pom files exist in the local maven repository, they
  // are usually not indexed because they are outside the source directory. We assume that they have
  // not been indexed.
  target = d.getPom() and
  // If we have a pom for the target of this dependency, then it is unused iff neither it, nor any
  // of its transitive dependencies are required.
  not exists(Pom exported | exported = target.getAnExportedPom*() |
    pomDependsOnContainer(source, exported.getAnExportedDependency().getJar()) or
    pomDependsOnPom(source, exported)
  )
select d, "Maven dependency onto " + d.getShortCoordinate() + " is unused."
