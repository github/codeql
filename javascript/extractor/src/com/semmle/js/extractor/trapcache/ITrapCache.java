package com.semmle.js.extractor.trapcache;

import com.semmle.js.extractor.ExtractorConfig;
import com.semmle.js.extractor.FileExtractor;
import java.io.File;

/** Generic TRAP cache interface. */
public interface ITrapCache {
  /**
   * Look up a file in the TRAP cache.
   *
   * @param source the content of the file
   * @param config the configuration options this file will be extracted with if it is not found in
   *     the cache
   * @param type the type of the file
   * @return {@literal null} if this TRAP cache does not support caching the given file; otherwise,
   *     a file in the TRAP cache which may either already exist (and then is guaranteed to hold
   *     cached information), or does not yet exist (and should be populated by the extractor)
   */
  public File lookup(String source, ExtractorConfig config, FileExtractor.FileType type);
}
