package com.semmle.js.parser;

import java.io.File;
import java.util.LinkedHashSet;
import java.util.Set;

public class ParsedProject {
  private final File tsConfigFile;
  private final Set<File> sourceFiles = new LinkedHashSet<>();

  public ParsedProject(File tsConfigFile) {
    this.tsConfigFile = tsConfigFile;
  }

  /** Returns the <tt>tsconfig.json</tt> file that defines this project. */
  public File getTsConfigFile() {
    return tsConfigFile;
  }

  /** Absolute paths to the files included in this project. */
  public Set<File> getSourceFiles() {
    return sourceFiles;
  }

  public void addSourceFile(File file) {
    sourceFiles.add(file);
  }
}
