package com.semmle.js.extractor;

import java.nio.file.Path;
import java.util.Collections;
import java.util.Map;

/**
 * Contains the results of installing dependencies.
 */
public class DependencyInstallationResult {
  private Map<Path, Path> originalFiles;
  
  public static final DependencyInstallationResult empty = new DependencyInstallationResult(Collections.emptyMap());

  public DependencyInstallationResult(Map<Path, Path> originalFiles) {
    this.originalFiles = originalFiles;
  }

  /**
   * Returns the mapping from files left behind by dependency installation to
   * the backups of those files, to be restored after extraction.
   */
  public Map<Path, Path> getOriginalFiles() {
    return originalFiles;
  }
}
