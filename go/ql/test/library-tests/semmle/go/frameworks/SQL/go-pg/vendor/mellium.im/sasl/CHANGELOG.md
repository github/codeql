# Changelog

All notable changes to this project will be documented in this file.


##  v0.3.1 — 2022-12-28

### Fixed

- Sometimes the nonce was not set on the SASL state machine, resulting in
  authentication failing


##  v0.3.0 — 2022-08-15

### Added

- Support for tls-exporter channel binding method as defined in [RFC 9266]
- Support for fast XOR using SIMD/VSX on more architectures


### Fixed

- Return an error if no tls-unique channel binding (CB) data is present in the
  TLS connection state (or no connection state exists) and we use SCRAM with CB


[RFC 9266]: https://datatracker.ietf.org/doc/html/rfc9266
