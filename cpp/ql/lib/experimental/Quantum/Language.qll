private import Base
private import cpp as Lang

module CryptoInput implements InputSig<Lang::Location> {
  class LocatableElement = Lang::Locatable;
}

module Crypto = CryptographyBase<Lang::Location, CryptoInput>;

import OpenSSL
