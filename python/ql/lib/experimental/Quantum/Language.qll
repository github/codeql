private import Base
private import python as Lang

module CryptoInput implements InputSig<Lang::Location> {
  class LocatableElement = Lang::Expr;

  class UnknownLocation = Lang::UnknownDefaultLocation;
}

module Crypto = CryptographyBase<Lang::Location, CryptoInput>;

import PycaCryptography
