package com.semmle.js.extractor.trapcache;

import static com.semmle.js.extractor.ExtractorOptionsUtil.readExtractorOption;

import com.semmle.js.extractor.ExtractorConfig;
import com.semmle.js.extractor.FileExtractor;
import com.semmle.js.extractor.Main;
import com.semmle.util.exception.UserError;
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

  /**
  * Build a TRAP cache as defined by the extractor options, which are read from the corresponding
  * environment variables as defined in
  * https://github.com/github/codeql-core/blob/main/design/spec/codeql-extractors.md
  *
  * @return a TRAP cache
  */
  public static ITrapCache fromExtractorOptions() {
    String trapCachePath = readExtractorOption("trap", "cache", "dir");
    if (trapCachePath != null) {
      Long sizeBound = null;
      String trapCacheBound = readExtractorOption("trap", "cache", "bound");
      if (trapCacheBound != null) {
        sizeBound = DefaultTrapCache.asFileSize(trapCacheBound);
        if (sizeBound == null)
          throw new UserError("Invalid TRAP cache size bound: " + trapCacheBound);
      }
      boolean writeable = true;
      String trapCacheWrite = readExtractorOption("trap", "cache", "write");
      if (trapCacheWrite != null) writeable = trapCacheWrite.equalsIgnoreCase("TRUE");
      return new DefaultTrapCache(trapCachePath, sizeBound, Main.EXTRACTOR_VERSION, writeable);
    }
    return new DummyTrapCache();
  }
}
