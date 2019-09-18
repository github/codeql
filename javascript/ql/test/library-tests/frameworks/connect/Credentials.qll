import javascript

query predicate test_Credentials(Connect::Credentials cr, string res) {
  res = cr.getCredentialsKind()
}
