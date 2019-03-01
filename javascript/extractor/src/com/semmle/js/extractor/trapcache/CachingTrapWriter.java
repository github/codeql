package com.semmle.js.extractor.trapcache;

import com.semmle.util.exception.Exceptions;
import com.semmle.util.files.FileUtil;
import com.semmle.util.trap.TrapWriter;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

/**
 * A trap writer for use with a trap cache.
 *
 * <p>A caching trap writer mainly works with two files: a result file to which tuples should be
 * appended, and a cache file that should be atomically overwritten with the complete list of tuples
 * produced by this writer once it is closed.
 *
 * <p>To achieve the latter, the trap writer writes all tuples to a temporary file first. When the
 * writer is closed (and extraction has succeeded), it atomically moves the temporary file over the
 * cache file.
 *
 * <p>This is similar to a concurrent trap writer, but a caching trap writer ensures that the trap
 * file is overwritten atomically. If this is impossible, the cached file will not be updated at
 * all.
 *
 * <p>In summary, a {@code CachingTrapWriter} keeps track of three files:
 *
 * <ul>
 *   <li>a temporary file to which tuples produced by this writer are written, referenced by field
 *       {@code tmpFile};
 *   <li>a cache file that is atomically overwritten with the contents of the temporary file when
 *       this writer is closed, referenced by field {@code trapFile};
 *   <li>a result file to which the contents of the temporary file are appended when this writer is
 *       closed, referenced by field {@code resultFile}.
 * </ul>
 */
public class CachingTrapWriter extends TrapWriter {
  private final File resultFile;

  // whether extraction was successful
  private boolean successful = true;

  public CachingTrapWriter(File cacheFile, File resultFile) {
    super(cacheFile, true);
    this.resultFile = resultFile;
  }

  /**
   * Tell the writer that extraction was not successful; the cache file and the result file will not
   * be updated.
   */
  public void discard() {
    successful = false;
  }

  @Override
  public void close() {
    FileUtil.close(out);

    try {
      if (successful) {
        // first append tuples from temporary file to result file (in case the move fails)
        FileUtil.append(tmpFile, resultFile);
        // then try to atomically move temporary file over cache file
        Files.move(tmpFile.toPath(), trapFile.toPath(), StandardCopyOption.ATOMIC_MOVE);
      }
    } catch (IOException e) {
      Exceptions.ignore(e, "Failed atomic moves are preferable to cache corruption.");
    } finally {
      // make sure to delete the temporary file in case the move failed
      tmpFile.delete();
    }
  }
}
