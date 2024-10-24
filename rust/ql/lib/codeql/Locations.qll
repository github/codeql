/** Provides classes for working with locations. */

import files.FileSystem
private import codeql.rust.elements.internal.LocationImpl

/**
 * A location as given by a file, a start line, a start column,
 * an end line, and an end column.
 *
 * For more information about locations see [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
 */
final class Location = LocationImpl::Location;

/** An entity representing an empty location. */
final class EmptyLocation = LocationImpl::EmptyLocation;
