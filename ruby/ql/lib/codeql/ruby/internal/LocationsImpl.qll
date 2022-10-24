/**
 * Provides an implementation of `LocationsSig` from the `codeql/utils` package.
 */

private import codeql.utils.Locations as Locs

/** An implementation of `LocationsSig`. */
module LocationsImpl implements Locs::LocationsSig {
  abstract class Container extends @container {
    abstract string getAbsolutePath();

    Container getParentContainer() { containerparent(result, this) }

    string toString() { result = this.getAbsolutePath() }
  }

  class File extends @file, Container {
    override string getAbsolutePath() { files(this, result) }
  }

  class Folder extends Container, @folder {
    override string getAbsolutePath() { folders(this, result) }
  }

  string getSourceLocationPrefix() { sourceLocationPrefix(result) }

  class Location = @location_default;

  predicate locations(
    Location loc, File file, int startLine, int startColum, int endLine, int endColumn
  ) {
    locations_default(loc, file, startLine, startColum, endLine, endColumn)
  }
}

/** An instantiation of the shared Locations module. */
module Inst = Locs::Make<LocationsImpl>;
