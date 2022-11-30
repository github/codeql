/**
 * @name Extraction metrics file data
 * @description Extraction metrics and related information for profiling the extraction of individual files.
 * @kind table
 * @id js/meta/extraction/file-data
 * @tags meta
 */

import javascript
import semmle.javascript.meta.ExtractionMetrics::ExtractionMetrics

FileWithExtractionMetrics getACacheMember(string cacheFile) { cacheFile = result.getCacheFile() }

FileWithExtractionMetrics getACacheHit(FileWithExtractionMetrics f) {
  result = getACacheMember(f.getCacheFile()) and
  result.isFromCache()
}

from FileWithExtractionMetrics fileWithMetrics, boolean fromCache
where (if fileWithMetrics.isFromCache() then fromCache = true else fromCache = false)
select fileWithMetrics.getAbsolutePath() as file, fileWithMetrics.getCpuTime() as cpu_nano,
  fileWithMetrics.getNumberOfLines() as lines,
  count(Locatable n | n.getFile() = fileWithMetrics) as locatables,
  count(TypeAnnotation n | n.getFile() = fileWithMetrics) as types,
  fileWithMetrics.getLength() as length, fromCache as from_cache,
  count(getACacheMember(fileWithMetrics.getCacheFile())) as cache_members,
  count(getACacheHit(fileWithMetrics)) as cache_hits, fileWithMetrics.getCacheFile() as cache_file
