/**
 * @name Unused Maven dependency (binary)
 * @description Unnecessary Maven dependencies are a maintenance burden.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/unused-maven-binary-dependency
 */

import UnusedMavenDependencies

/**
 * A whitelist of binary dependencies that should never be highlighted as unusued.
 */
predicate whitelist(Dependency d) {
  // jsr305 contains package annotations. If a project uses those exclusively, we will
  // consider it "unused".
  d.getShortCoordinate() = "com.google.code.findbugs:jsr305"
}

from PomDependency d, Pom source
where
  source.getADependency() = d and
  // There is not a Pom file for the target of this dependency, so we assume that it was resolved by
  // a binary file in the local maven repository.
  not exists(Pom target | target = d.getPom()) and
  // In order to accurately identify whether this binary dependency is required, we must have identified
  // a Maven repository. If we have not found a repository, it's likely that it has a custom path of
  // which we are unaware, so do not report any problems.
  exists(MavenRepo mr) and
  // We either haven't indexed a relevant jar file, which suggests that nothing statically depended upon
  // it, or we have indexed the relevant jar file, but no source code in the project defined by the pom
  // depends on any code within the detected jar.
  not pomDependsOnContainer(source, d.getJar()) and
  // If something that depends on us depends on the jar represented by this dependency, and it doesn't
  // depend directly on the jar itself, we don't consider it to be "unused".
  not exists(Pom pomThatDependsOnSource | pomThatDependsOnSource.getAnExportedPom+() = source |
    pomDependsOnContainer(pomThatDependsOnSource, d.getJar()) and
    not exists(File f | f = pomThatDependsOnSource.getADependency().getJar() and f = d.getJar())
  ) and
  // Filter out those dependencies on the whitelist
  not whitelist(d)
select d, "Maven dependency on the binary package " + d.getShortCoordinate() + " is unused."
