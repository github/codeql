import javascript

query predicate test_Credentials(Express::Credentials cr, string res) {
  res = cr.getCredentialsKind()
}
