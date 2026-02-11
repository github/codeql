/** Provides classes for working with locations. */

import files.FileSystem
private import codeql.rust.elements.internal.LocationImpl

final class Location = LocationImpl::Location;

final class EmptyLocation = LocationImpl::EmptyLocation;
