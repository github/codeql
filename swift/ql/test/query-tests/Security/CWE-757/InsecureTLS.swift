// Stubs

enum tls_protocol_version_t : UInt16 {
  case TLSv10
  case TLSv11
  case TLSv12
  case TLSv13
}

enum SSLProtocol {
  case tlsProtocol10
  case tlsProtocol11
  case tlsProtocol12
  case tlsProtocol13
}

class URLSessionConfiguration {
  init() {}
  var tlsMinimumSupportedProtocolVersion: tls_protocol_version_t = tls_protocol_version_t.TLSv12
  var tlsMaximumSupportedProtocolVersion: tls_protocol_version_t = tls_protocol_version_t.TLSv13

  var tlsMinimumSupportedProtocol: SSLProtocol = SSLProtocol.tlsProtocol12
  var tlsMaximumSupportedProtocol: SSLProtocol = SSLProtocol.tlsProtocol13
}

/// tlsMinimumSupportedProtocolVersion

func case_0() {
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = tls_protocol_version_t.TLSv12 // GOOD
}

func case_1() {
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = tls_protocol_version_t.TLSv13 // GOOD
}

func case_2() {
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = tls_protocol_version_t.TLSv10 // BAD
}

func case_3() {
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = tls_protocol_version_t.TLSv11 // BAD
}

/// tlsMaximumSupportedProtocolVersion

func case_4() {
  let config = URLSessionConfiguration()
  config.tlsMaximumSupportedProtocolVersion = tls_protocol_version_t.TLSv12 // GOOD
}

func case_5() {
  let config = URLSessionConfiguration()
  config.tlsMaximumSupportedProtocolVersion = tls_protocol_version_t.TLSv10 // BAD
}

/// tlsMinimumSupportedProtocol

func case_6() {
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocol = SSLProtocol.tlsProtocol10 // BAD
}

func case_7() {
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocol = SSLProtocol.tlsProtocol12 // GOOD
}

/// tlsMaximumSupportedProtocol

func case_8() {
  let config = URLSessionConfiguration()
  config.tlsMaximumSupportedProtocol = SSLProtocol.tlsProtocol10 // BAD
}

func case_9() {
  let config = URLSessionConfiguration()
  config.tlsMaximumSupportedProtocol = SSLProtocol.tlsProtocol12 // GOOD
}

/// Indirect assignment (global vars)

let badGlobalVersion = tls_protocol_version_t.TLSv10
let goodGlobalVersion = tls_protocol_version_t.TLSv12

func case_10() {
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = badGlobalVersion // BAD [not detected]
}

func case_11() {
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = goodGlobalVersion // GOOD
}

/// Indirect assignment (function calls)

func getBadTLSVersion() -> tls_protocol_version_t {
  return tls_protocol_version_t.TLSv10
}

func getGoodTLSVersion() -> tls_protocol_version_t {
  return tls_protocol_version_t.TLSv13
}

func case_12() {
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = getBadTLSVersion() // BAD
}

func case_13() {
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = getGoodTLSVersion() // GOOD
}

/// Indirect assignment (via call arguments)

func setTLSVersion(_ config: URLSessionConfiguration, _ version: tls_protocol_version_t) {
  config.tlsMinimumSupportedProtocolVersion = version
}

func case_14() {
  let config = URLSessionConfiguration()
  setTLSVersion(config, tls_protocol_version_t.TLSv11) // BAD
}

func case_15() {
  let config = URLSessionConfiguration()
  setTLSVersion(config, tls_protocol_version_t.TLSv13) // GOOD
}

/// Indirect assignment (via external entity)

struct BadDefault {
  let TLSVersion: tls_protocol_version_t = tls_protocol_version_t.TLSv11
}

func case_16() {
  let def = BadDefault()
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = def.TLSVersion // BAD [not detected]
}

struct GoodDefault {
  let TLSVersion: tls_protocol_version_t = tls_protocol_version_t.TLSv12
}

func case_17() {
  let def = GoodDefault()
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = def.TLSVersion // GOOD
}

struct VarDefault {
  var TLSVersion: tls_protocol_version_t = tls_protocol_version_t.TLSv12
}

func case_18() {
  var def = VarDefault()
  def.TLSVersion = tls_protocol_version_t.TLSv10
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = def.TLSVersion // BAD
}

func case_19() {
  var def = VarDefault()
  def.TLSVersion = tls_protocol_version_t.TLSv13
  let config = URLSessionConfiguration()
  config.tlsMinimumSupportedProtocolVersion = def.TLSVersion // GOOD
}

class MyClass {
  var config = URLSessionConfiguration()
}

func case_20(myObj: MyClass) {
  myObj.config.tlsMinimumSupportedProtocolVersion = tls_protocol_version_t.TLSv13 // GOOD
  myObj.config.tlsMinimumSupportedProtocolVersion = tls_protocol_version_t.TLSv10 // BAD
}

extension URLSessionConfiguration {
  convenience init(withMinVersion: tls_protocol_version_t) {
    self.init()
    tlsMinimumSupportedProtocolVersion = withMinVersion
  }
}

func case_21() {
  let _ = URLSessionConfiguration(withMinVersion: tls_protocol_version_t.TLSv13) // GOOD
  let _ = URLSessionConfiguration(withMinVersion: tls_protocol_version_t.TLSv10) // BAD
}

func setVersion(version: inout tls_protocol_version_t, value: tls_protocol_version_t) {
  version = value
}

func case_22(config: URLSessionConfiguration) {
  setVersion(version: &config.tlsMinimumSupportedProtocolVersion, value: tls_protocol_version_t.TLSv13) // GOOD
  setVersion(version: &config.tlsMinimumSupportedProtocolVersion, value: tls_protocol_version_t.TLSv10) // BAD
}
