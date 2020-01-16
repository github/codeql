package com.semmle.js.extractor;

import java.nio.file.Path;
import java.util.Collections;
import java.util.Map;

/** Contains the results of installing dependencies. */
public class DependencyInstallationResult {
  private Map<String, Path> packageLocations;

  public static final DependencyInstallationResult empty =
      new DependencyInstallationResult(Collections.emptyMap());

  public DependencyInstallationResult(Map<String, Path> localPackages) {
    this.packageLocations = localPackages;
  }

  /**
   * Returns the mapping from package names to the TypeScript file that should
   * act as its main entry point.
   */
  public Map<String, Path> getPackageLocations() {
    return packageLocations;
  }
}
