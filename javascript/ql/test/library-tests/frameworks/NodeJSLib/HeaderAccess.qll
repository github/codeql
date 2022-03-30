import javascript

query predicate test_HeaderAccess(HTTP::RequestHeaderAccess access, string res) {
  res = access.getAHeaderName()
}
