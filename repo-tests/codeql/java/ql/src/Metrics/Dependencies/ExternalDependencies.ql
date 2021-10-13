/**
 * @deprecated
 * @name External dependencies
 * @description Count the number of dependencies a Java source file has on jar files.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType externalDependency
 * @id java/external-dependencies
 */

import java
import semmle.code.java.DependencyCounts

/*
 * These two columns encode four logical columns:
 *
 * 1. Java source file where the dependency originates
 * 2. Name of the JAR file containing the target of the dependency
 * 3. Best guess at a version based on a dashed suffix of the JAR file
 * 4. Number of dependencies from the Java file to the jar
 *
 * Ideally this query would therefore return four columns,
 * but this would require changing the dashboard database schema
 * and dashboard extractor.
 *
 * The first column (the Java source file) is prepended with a '/'
 * so that the file path matches the path used for the file in the
 * dashboard database, which is implicitly relative to the source
 * archive location.
 */

from File sourceFile, int total, string entity
where fileJarDependencyCount(sourceFile, total, entity)
select entity, total order by total desc
