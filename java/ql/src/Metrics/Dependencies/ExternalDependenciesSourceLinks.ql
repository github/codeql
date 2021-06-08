/**
 * @deprecated
 * @name External dependency source links
 * @kind source-link
 * @metricType externalDependency
 * @id java/dependency-source-links
 */

import java
import semmle.code.java.DependencyCounts

/*
 * This query creates the source links for the ExternalDependencies.ql query.
 * Although the entities in question are of the form '/file/path<|>dependency<|>version',
 * the /file/path is a bare string relative to the root of the source archive, and not
 * tied to a particular revision. We need the File entity (the second column here) to
 * recover that information once we are in the dashboard database, using the
 * ExternalEntity.getASourceLink() method.
 */

from File sourceFile, string entity
where fileJarDependencyCount(sourceFile, _, entity)
select entity, sourceFile
