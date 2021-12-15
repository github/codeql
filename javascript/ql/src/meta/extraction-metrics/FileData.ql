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

from FileWithExtractionMetrics file, boolean fromCache
where (if file.isFromCache() then fromCache = true else fromCache = false)
select file.getAbsolutePath() as FILE, file.getCpuTime() as CPU_NANO,
  file.getNumberOfLines() as LINES, count(Locatable n | n.getFile() = file) as LOCATABLES,
  count(TypeAnnotation n | n.getFile() = file) as TYPES, file.getLength() as LENGTH,
  fromCache as FROM_CACHE, count(getACacheMember(file.getCacheFile())) as CACHE_MEMBERS,
  count(getACacheHit(file)) as CACHE_HITS, file.getCacheFile() as CACHE_FILE
