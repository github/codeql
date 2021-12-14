/**
 * @deprecated
 * @name External dependency source links
 * @kind source-link
 * @metricType externalDependency
 * @id py/dependency-source-links
 */

import python
import semmle.python.dependencies.TechInventory

/*
 * This query creates the source links for the ExternalDependencies.ql query.
 * Although the entities in question are of the form '/file/path<|>dependency', the
 * /file/path is a bare string relative to the root of the source archive, and not
 * tied to a particular revision. We need the File entity (the second column here) to
 * recover that information once we are in the dashboard database, using the
 * ExternalEntity.getASourceLink() method.
 */

from File sourceFile, string entity
where
  exists(PackageObject package, AstNode src |
    dependency(src, package) and
    src.getLocation().getFile() = sourceFile and
    entity = munge(sourceFile, package)
  )
select entity, sourceFile
