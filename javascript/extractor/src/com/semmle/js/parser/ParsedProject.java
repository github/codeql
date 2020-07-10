package com.semmle.js.parser;

import java.io.File;
import java.util.Set;

public class ParsedProject {
  private final File tsConfigFile;
  private final Set<File> ownFiles;
  private final Set<File> allFiles;

  public ParsedProject(File tsConfigFile, Set<File> ownFiles, Set<File> allFiles) {
    this.tsConfigFile = tsConfigFile;
    this.ownFiles = ownFiles;
    this.allFiles = allFiles;
  }

  /** Returns the <tt>tsconfig.json</tt> file that defines this project. */
  public File getTsConfigFile() {
    return tsConfigFile;
  }

  /** Absolute paths to the files included in this project. */
  public Set<File> getOwnFiles() {
    return allFiles;
  }

  /** Absolute paths to the files included in or referenced by this project. */
  public Set<File> getAllFiles() {
    return allFiles;
  }
}
