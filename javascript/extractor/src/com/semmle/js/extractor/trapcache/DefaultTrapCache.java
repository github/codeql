package com.semmle.js.extractor.trapcache;

import com.semmle.js.extractor.ExtractorConfig;
import com.semmle.js.extractor.FileExtractor.FileType;
import com.semmle.util.data.Pair;
import com.semmle.util.data.StringDigestor;
import com.semmle.util.data.UnitParser;
import com.semmle.util.exception.Exceptions;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.files.FileUtil;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

/** The default TRAP cache implementation. */
public class DefaultTrapCache implements ITrapCache {
  private final File trapCache;

  /**
   * A version identifier for the extractor whose TRAP files we are caching.
   *
   * <p>The same source code of the same {@link FileType} extracted twice with the same extractor
   * version and under the same {@link ExtractorConfig} should yield semantically equivalent sets of
   * tuples.
   */
  private final String extractorVersion;

  public DefaultTrapCache(String trapCache, Long sizeBound, String extractorVersion) {
    this.trapCache = new File(trapCache);
    this.extractorVersion = extractorVersion;
    try {
      initCache(sizeBound);
    } catch (ResourceError | SecurityException e) {
      throw new ResourceError("Could not initialize trap cache at " + trapCache, e);
    }
  }

  /**
   * Initialise the TRAP cache.
   *
   * <p>This creates the cache directory (if it does not exist yet), and trims the cache to fit
   * within the size bounds specified in its <code>size.bounds</code> file (if specified).
   *
   * <p>To trim the cache size, the files in the cache are traversed in some unspecified order, and
   * their sizes are summed up; if their total size exceeds the high water mark specified in <code>
   * size.bounds</code>, files are deleted to reduce the cache size to less than the low water mark.
   *
   * <p>If any of these steps fail, we silently give up. Hence there is no guarantee that the cache
   * will actually be smaller than the low water mark after initialisation.
   */
  private void initCache(Long sizeBound) {
    FileUtil.mkdirs(this.trapCache);

    try {
      Long lowWaterMark, highWaterMark;

      if (sizeBound != null) {
        highWaterMark = sizeBound;
        lowWaterMark = (long) (0.4 * highWaterMark);
      } else {
        Pair<Long, Long> watermarks = readCacheSizeBounds();
        if (watermarks == null) return;
        lowWaterMark = watermarks.fst();
        highWaterMark = watermarks.snd();
      }

      trimCacheToSize(lowWaterMark, highWaterMark);
    } catch (IOException | SecurityException e) {
      Exceptions.ignore(e, "Cache size management is optional.");
    }
  }

  private void trimCacheToSize(long lo, long hi) {
    // all `.trap.gz` files in the cache, in some unspecified order
    File[] files = this.trapCache.listFiles(FileUtil.extensionFilter(true, ".trap.gz"));

    // cumulative size of all files we have seen so far
    long cur = 0;

    // index of first file where cumulative size exceeds low water mark;
    // set to files.length to indicate that the low water mark was not exceeded
    int firstPastLo = files.length;

    for (int i = 0; i < files.length; ++i) {
      File f = files[i];
      cur += f.length();
      if (firstPastLo == files.length && cur > lo) firstPastLo = i;
      if (cur > hi) break;
    }

    // if the high water mark was exceeded, delete files starting at `firstPastLo`
    if (cur > hi) while (firstPastLo < files.length) files[firstPastLo++].delete();
  }

  /**
   * Read the cache size bounds for this TRAP cache.
   *
   * <p>Cache size bounds are specified on the first line of a file called <code>size.bounds</code>
   * in the cache directory (any subsequent lines are ignored).
   *
   * <p>Two bounds are specified, separated by a colon: the first is a low water mark, the second a
   * high water mark. The high water mark may be omitted, in which case it defaults to the low water
   * mark. Both bounds should be specified as using file size units, cf. {@link
   * UnitParser#MEGABYTES}.
   *
   * @return a pair of file sizes in bytes, or {@code null} if the sizes could not be determined for
   *     whatever reason
   */
  private Pair<Long, Long> readCacheSizeBounds() throws IOException {
    File cacheSizeFile = new File(this.trapCache, "size.bounds");
    if (!cacheSizeFile.canRead()) return null;
    try (BufferedReader br = new BufferedReader(new FileReader(cacheSizeFile))) {
      String firstLine = br.readLine();
      if (firstLine == null) return null;
      String[] sizes = firstLine.split(":");
      Long lo = sizes.length < 1 ? null : asFileSize(sizes[0]);
      Long hi = sizes.length < 2 ? lo : asFileSize(sizes[1]);
      if (lo == null || hi == null || hi < lo) return null;
      return Pair.make(lo, hi);
    }
  }

  public static Long asFileSize(String s) {
    Integer tmp = UnitParser.parseOpt(s, UnitParser.MEGABYTES);
    if (tmp == null) return null;
    return tmp.longValue() * 1024 * 1024;
  }

  @Override
  public File lookup(String source, ExtractorConfig config, FileType type) {
    // compute a hash for this file based on its contents and the configuration options
    StringDigestor digestor = new StringDigestor();
    digestor.write(extractorVersion);
    digestor.write(type.toString());
    digestor.write(config);
    digestor.write(source);
    return new File(trapCache, digestor.getDigest() + ".trap.gz");
  }
}
