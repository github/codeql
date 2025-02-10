private import codeql.cryptography.Model
private import java as Lang

/**
 * A dummy location which is used when something doesn't have a location in
 * the source code but needs to have a `Location` associated with it. There
 * may be several distinct kinds of unknown locations. For example: one for
 * expressions, one for statements and one for other program elements.
 */
class UnknownLocation extends Location {
  UnknownLocation() { this.getFile().getAbsolutePath() = "" }
}

/**
 * A dummy location which is used when something doesn't have a location in
 * the source code but needs to have a `Location` associated with it.
 */
class UnknownDefaultLocation extends UnknownLocation {
  UnknownDefaultLocation() { locations_default(this, _, 0, 0, 0, 0) }
}

module CryptoInput implements InputSig<Lang::Location> {
  class LocatableElement = Lang::Element;

  class UnknownLocation = UnknownDefaultLocation;
}

module Crypto = CryptographyBase<Lang::Location, CryptoInput>;

import JCA
