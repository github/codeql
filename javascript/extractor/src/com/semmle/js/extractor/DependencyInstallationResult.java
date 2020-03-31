package com.semmle.js.extractor;

import java.nio.file.Path;
import java.util.Collections;
import java.util.Map;

/** Contains the results of installing dependencies. */
public class DependencyInstallationResult {
  private Path virtualSourceRoot;
  private Map<String, Path> packageEntryPoints;
  private Map<String, Path> packageJsonFiles;

  public static final DependencyInstallationResult empty =
      new DependencyInstallationResult(null, Collections.emptyMap(), Collections.emptyMap());

  public DependencyInstallationResult(
      Path virtualSourceRoot,
      Map<String, Path> packageEntryPoints,
      Map<String, Path> packageJsonFiles) {
    this.packageEntryPoints = packageEntryPoints;
    this.packageJsonFiles = packageJsonFiles;
  }

  /**
   * Returns the virtual source root or <code>null</code> if no virtual source root exists.
   *
   * The virtual source root is a directory hierarchy that mirrors the real source
   * root, where dependencies are installed.
   */
  public Path getVirtualSourceRoot() {
    return virtualSourceRoot;
  }

  /**
   * Returns the mapping from package names to the TypeScript file that should
   * act as its main entry point.
   */
  public Map<String, Path> getPackageEntryPoints() {
    return packageEntryPoints;
  }

  /**
   * Returns the mapping from package name to corresponding package.json.
   */
  public Map<String, Path> getPackageJsonFiles() {
    return packageJsonFiles;
  }
}
