/**
 * Provides models for the `FileManager` Swift class.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for `FileManager` members that are flow sources.
 *
 * Note that functions returning paths on the file system have been removed
 * from this model. Though they are in principle tainted by the data on the
 * local filesystem, in practice we've found results from them almost always
 * have little value.
 */
private class FileManagerSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        //";FileManager;true;contentsOfDirectory(at:includingPropertiesForKeys:options:);;;ReturnValue;local",
        //";FileManager;true;contentsOfDirectory(atPath:);;;ReturnValue;local",
        //";FileManager;true;directoryContents(atPath:);;;ReturnValue;local",
        //";FileManager;true;subpathsOfDirectory(atPath:);;;ReturnValue;local",
        //";FileManager;true;subpaths(atPath:);;;ReturnValue;local",
        //";FileManager;true;destinationOfSymbolicLink(atPath:);;;ReturnValue;local",
        //";FileManager;true;pathContentOfSymbolicLink(atPath:);;;ReturnValue;local",
        ";FileManager;true;contents(atPath:);;;ReturnValue;local"
      ]
  }
}
