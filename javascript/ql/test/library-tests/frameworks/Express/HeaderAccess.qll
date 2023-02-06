import javascript

query predicate test_HeaderAccess(Http::RequestHeaderAccess access, string res) {
  res = access.getAHeaderName()
}
