private import codeql.cryptography.Model
private import cpp as Lang

module CryptoInput implements InputSig<Lang::Location> {
  class LocatableElement = Lang::Locatable;

  class UnknownLocation = Lang::UnknownDefaultLocation;
}

module Crypto = CryptographyBase<Lang::Location, CryptoInput>;

import OpenSSL
