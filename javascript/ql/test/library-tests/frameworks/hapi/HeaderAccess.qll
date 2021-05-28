import javascript

query predicate test_HeaderAccess(https::RequestHeaderAccess access, string res) {
  res = access.getAHeaderName()
}
